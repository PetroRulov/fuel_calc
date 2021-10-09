defmodule FuelCalc.FcCacher do
  @moduledoc false

  @cache :fc_cache

  @doc """
  Create a new ETS Cache if it doesn't already exists
  """
  def start do
    :ets.new(@cache, [:set, :public, :named_table])
    :ok
  rescue
    ArgumentError -> {:error, :already_started}
  end

  @doc """
  Retreive a value back from cache
  """
  def get(key) do
    case :ets.lookup(@cache, key) do
      [{^key, value}] -> value
      _else -> nil
    end
  end

  @doc """
  Put a value into the cache
  """
  def put(key, value) do
    true = :ets.insert(@cache, {key, value})
    :ok
  end
end
