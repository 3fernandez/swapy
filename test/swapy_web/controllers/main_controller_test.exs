defmodule SwapyWeb.MainControllerTest do
  use SwapyWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  describe "create" do
    test "should return a :created status code and a successful msg", %{conn: conn} do
      expect(HTTPoison.BaseMock, :get!, fn _, _, _ ->
        %HTTPoison.Response{
          body: response_body() |> Jason.encode!(),
          status_code: 200
        }
      end)

      params = %{"user" => "user", "repo" => "repo"}
      response = post(conn, "/api/process_issues", params)

      assert %{status: 201, resp_body: "Job successfuly enqueued!"} = response
    end

    test "should return a 500 status code and an error msg", %{conn: conn} do
      response = post(conn, "/api/process_issues", %{user: "user"})

      assert %{status: 500, resp_body: "Unexpected params format!"} = response
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
