defmodule InfoCounter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InfoCounterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: InfoCounter.PubSub},
      # Start Finch
      {Finch, name: InfoCounter.Finch},
      # Start the Endpoint (http/https)
      InfoCounterWeb.Endpoint
      # Start a worker by calling: InfoCounter.Worker.start_link(arg)
      # {InfoCounter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InfoCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InfoCounterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
