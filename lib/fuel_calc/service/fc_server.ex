defmodule FuelCalc.Service.FcServer do
  @moduledoc false

  use GenServer

  require Logger

  alias FuelCalc.Computator

  def child_spec(init_args) do
    %{
      id: __MODULE__,
      start: {GenServer, :start_link, [__MODULE__, init_args, [name: __MODULE__]]},
      restart: :permanent
    }
  end

  def calculate([]) do
    GenServer.call(__MODULE__, {:calculate, []})
  end

  def calculate(params) do
    GenServer.call(__MODULE__, {:calculate, params})
  end

  # Callbacks

  @impl true
  def init(_init_args) do
    {:ok, %{ref: nil}}
  end

  @impl true
  def handle_call({:calculate, []}, _from, state) do
    {:reply, {:error, "Empty routes"}, %{state | ref: nil}}
  end

  def handle_call({:calculate, params}, _from, state) do
    task =
      Task.Supervisor.async_nolink(FuelCalc.TaskSupervisor, fn ->
        Computator.calculate_fuel(params)
      end)

    result = Task.await(task)
    {:reply, result, %{state | ref: task.ref}}
  end
end
