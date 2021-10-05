defmodule FuelCalc.Repo do
  @moduledoc """
  	In memory repository.
  """

  alias FuelCalc.Struct.By
  alias FuelCalc.Struct.Planet

  def all(By) do
    [
      %By{name: "Apollo_11", weight: "28801"},
      %By{name: "Mars_Mission", weight: "14606"},
      %By{name: "Passenger_Ship", weight: "75432"}
    ]
  end

  def all(Planet) do
    [
      %Planet{name: "Earth", gravity: "9807", exponent: "1"},
      %Planet{name: "Mars", gravity: "3711", exponent: "1"},
      %Planet{name: "Moon", gravity: "1620", exponent: "1"}
    ]
  end

  def all(_module), do: []
end
