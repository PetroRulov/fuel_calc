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

  def print(params) do
    GenServer.cast(__MODULE__, {:print, params})
  end

  def put_expert(params) do
    GenServer.cast(__MODULE__, {:put_expert, params})
  end

  def put_into_expert(params) do
    _ = :ets.insert_new(:expert, params)
    IO.inspect(:ets.tab2list(:expert), label: "EXPERT")
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

  @impl true
  def handle_cast({:print, []}, state) do
    IO.inspect([], label: "EMPTY_PARAMS")
    {:noreply, %{state | ref: nil}}
  end

  def handle_cast({:print, params}, state) do
    IO.inspect(params, label: "PARAMS_TO_PRINT")
    {:noreply, %{state | ref: nil}}
  end

  def handle_cast({:put_expert, {_key, _value} = params}, state) do
    put_into_expert(params)

    case Node.list() do
      [] ->
        Logger.debug "NO CLUSTER"
        :ok
      nodes_list ->
        Logger.debug "CLUSTER EXISTS!!!"
        :ok = make_rpc_cast(nodes_list, params)
    end

    {:noreply, %{state | ref: nil}}
  end

  defp make_rpc_cast([], _params) do
    :ok
  end

  defp make_rpc_cast([h | t], params) do
    :rpc.cast(h, __MODULE__, :put_into_expert, [params]) 
    make_rpc_cast(t, params)
  end
end
