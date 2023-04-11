defmodule Swapy.FancyJobScheduler do
  @moduledoc """
  My custom job scheduler implementation, that leverages 
  an Elixir generic server process.
  """

  use GenServer

  alias Swapy.{DataStream, FancyStore}

  @time_interval 24

  # Client

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def schedule_job(name \\ __MODULE__) do
    GenServer.cast(name, :schedule_job)
  end

  # Server Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:schedule_job, state) do
    set_countdown_timer()

    {:noreply, state}
  end

  @impl true
  def handle_info(:process_job, state) do
    {:ok, [body]} = FancyStore.all()
    DataStream.send_issues(body)

    {:noreply, state}
  end

  defp set_countdown_timer() do
    # The send_after/3 fn accepts interval in ms as the 3rd arg, 
    # and that's why I'm using the formula hr * min * secs * ms.
    # Process.send_after(self(), :process_job, @time_interval * 60 * 60 * 1000)
    Process.send_after(self(), :process_job, 15_000)
  end
end
