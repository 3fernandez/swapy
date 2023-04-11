defmodule Swapy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SwapyWeb.Telemetry,
      # Start our Fancy key/value store
      %{id: Swapy.FancyStore, start: {Swapy.FancyStore, :start_link, []}},
      # Start the PubSub system
      {Phoenix.PubSub, name: Swapy.PubSub},
      # Start the Endpoint (http/https)
      SwapyWeb.Endpoint
      # Start a worker by calling: Swapy.Worker.start_link(arg)
      # {Swapy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Swapy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SwapyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
