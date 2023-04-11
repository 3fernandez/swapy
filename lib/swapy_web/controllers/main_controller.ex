defmodule SwapyWeb.MainController do
  use SwapyWeb, :controller

  alias Swapy.JobProcessor

  def create(conn, params) do
    case JobProcessor.enqueue_job(params) do
      {:ok, feedback_msg} ->
        send_resp(conn, 201, feedback_msg)

      {:error, error} ->
        send_resp(conn, 500, error)
    end
  end
end
