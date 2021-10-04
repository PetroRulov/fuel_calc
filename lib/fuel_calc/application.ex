defmodule FuelCalc.Application do
 
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FuelCalcWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FuelCalc.PubSub},
      # Start the Endpoint (http/https)
      FuelCalcWeb.Endpoint,
###      # Start a worker by calling: FuelCalc.Computator.start_link(arg)
      FuelCalc.FcServer,
      {Task.Supervisor, name: FuelCalc.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FuelCalc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FuelCalcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
