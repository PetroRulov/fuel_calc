defmodule FuelCalc.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FuelCalcWeb.Telemetry,
      {Phoenix.PubSub, name: FuelCalc.PubSub},
      FuelCalcWeb.Endpoint,
      FuelCalc.Service.FcServer,
      {Task.Supervisor, name: FuelCalc.TaskSupervisor}
    ]
    opts = [strategy: :one_for_one, name: FuelCalc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    FuelCalcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
