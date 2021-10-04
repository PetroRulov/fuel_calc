defmodule FuelCalc.Helpers do

	@moduledoc """
		Fuel_calc app Repo helper.
	"""

	alias FuelCalc.Struct.By
	alias FuelCalc.Struct.Planet

	@transports FuelCalc.Repo.all(FuelCalc.Struct.By)
	@planets FuelCalc.Repo.all(FuelCalc.Struct.Planet)

	@spec get_gravity_by_name(binary()) :: {:ok | :error, float()}
	def get_gravity_by_name(planet_name) do
		case Enum.filter(@planets, fn %{name: name} -> name == planet_name end) do
			[%Planet{exponent: exp_signs_quant_str, gravity: str_gravity, name: ^planet_name}] ->
				{:ok, get_float_gravity(str_gravity, exp_signs_quant_str)}
			[] ->
				{:error, 0.0}
		end
	end

	@spec get_float_gravity(binary(), binary()) :: float()
	def get_float_gravity(str_gravity, exp_signs_quant_str) do
		exponent = String.to_integer(exp_signs_quant_str)
		mantissa = byte_size(str_gravity) - exponent
		<<e::binary-size(exponent), m::binary-size(mantissa)>> = str_gravity
		String.to_float(e <> "." <> m)
	end

	@spec get_weight_by_name(binary()) :: {:ok | :error, integer()}
	def get_weight_by_name(transport_name) do
		case Enum.filter(@transports, fn %{name: name} -> name == transport_name end) do
			[%By{name: ^transport_name, weight: weight}] ->
				{:ok, String.to_integer(weight)}
			[] ->
				{:error, 0}
		end
	end

end