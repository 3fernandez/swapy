defmodule Swapy.JobProcessorTest do
  use ExUnit.Case

  import Mox

  alias Swapy.JobProcessor

  describe "enqueue_job/1" do
    test "should successfuly enqueue job to be later proccessed" do
      expect(HTTPoison.BaseMock, :get!, fn _, _, _ ->
        %HTTPoison.Response{
          body: response_body() |> Jason.encode!(),
          status_code: 200
        }
      end)

      params = %{"user" => "user", "repo" => "repo"}

      assert {:ok, "Job successfuly enqueued!"} = JobProcessor.enqueue_job(params)
    end

    test "should fail to enqueue job when unexpected params are provided" do
      params = %{unexpected: "unexpected"}

      assert {:error, "Unexpected params format!"} = JobProcessor.enqueue_job(params)
    end
  end

  defp response_body() do
    [
      %{
        labels: [
          %{
            color: "84b6eb",
            default: true,
            description: nil,
            id: 513_472_665,
            name: "enhancement",
            node_id: "MDU6TGFiZWw1MTM0NzI2NjU=",
            url: "https://api.github.com/repos/worknenjoy/truppie/labels/enhancement"
          }
        ],
        title: "Receive e-mail about new guide registration",
        user: %{
          login: "alexanmtz"
        }
      }
    ]
  end
end
