defmodule Swapy.JobProcessor do
  @moduledoc """
  The JobProcessor module will act as an orchestrator, 
  it will be responsible for enqueing the job, wich means: 

  - Use DataStream to lazily fetch all the pages, in case of paginated endpoint;
  - Save it temporarily into the vey/value store(FancyStore);
  - And set the countdown to dispatch the async request;
  """

  alias Swapy.{DataStream, FancyStore, FancyJobScheduler}

  def enqueue_job(%{"user" => user, "repo" => repo} = params) do
    resource_path = "/#{user}/#{repo}/issues"

    response =
      resource_path
      |> DataStream.new()
      |> Enum.to_list()

    case enqueue(params, response) do
      :ok -> {:ok, "Job successfuly enqueued!"}
      _unexpected -> {:error, "Something unexpected happened!"}
    end
  end

  def enqueue_job(_params), do: {:error, "Unexpected params format!"}

  defp enqueue(params, response) do
    data_row = %{user: params["user"], repository: params["repo"], issues: response}

    with :ok <- FancyStore.put(params, data_row),
         :ok <- FancyJobScheduler.schedule_job() do
      :ok
    end
  end
end
