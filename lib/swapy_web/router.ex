defmodule SwapyWeb.Router do
  use SwapyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SwapyWeb do
    pipe_through :api
  end
end
