defmodule FuelCalc.Computator do

	@moduledoc false

	alias FuelCalc.Helpers

	require Logger

	@launch 0.042
	@landing 0.033
	@launch_round 33
	@landing_round 42
	
	@spec calculate_fuel(list()) :: {:ok, map()} | {:error, binary()}
	def calculate_fuel([%{"launch" => launch} | _tail])
	when launch != "Earth" do
  		{:error, "Wrong route: First spaceship launch should always be from planet Earth!!!"}
	end

	def calculate_fuel(params) do
		reversed_routes = [%{"landing" => landing} | _tail] = Enum.reverse(params)
		case landing != "Earth" do
			true ->
  				{:error, "Wrong route: The spaceship must always return to planet Earth"}
			false ->
        case check_one_transport(params) do
          {:ok, _} ->
            calculate_fuel(reversed_routes, [], 0)
          {:error, msg} ->
            {:error, msg}
        end
		end
	end

	defp calculate_fuel([], acc, total) do
  		{:ok, %{:routes => acc, :fuel => total, :msg => "SUCCESS: minimum required fuel amount: #{total}"}}
  	end

  	defp calculate_fuel([head | tail], acc, append_fuel) do
  		case calculate_route(head, append_fuel) do
  			{:error, message} ->
  				{:error, message}
  			fuel when is_integer(fuel) ->
  				calculate_fuel(tail, [{head, fuel} | acc], fuel + append_fuel)
  		end
  	end

  	defp calculate_route(%{"by" => by, "launch" => same, "landing" => same}, _) do
  		Logger.error "Space flight by #{by} from #{same} to #{same}"
  		{:error, "Wrong destination: Launch planet and landing planet are the SAME"}
  	end

  	defp calculate_route(%{"by" => by_str, "launch" => launch_str, "landing" => landing_str}, append_fuel) do
  		case Helpers.get_weight_by_name(by_str) do
  			{:ok, weight} -> 
  				get_launch_gravity(weight + append_fuel, launch_str, landing_str)
  			{:error, _} ->
  				{:error, "Wrong transport name chosen in the route"}
  		end
  	end

  	defp get_launch_gravity(weight, launch_str, landing_str) do
  		case Helpers.get_gravity_by_name(launch_str) do
  			{:ok, gravity} -> 
  				get_landing_gravity(weight, %{:launch => gravity}, landing_str)
  			{:error, _} ->
  				{:error, "Wrong planet name for LAUNCH in the route"}
  		end
  	end

  	defp get_landing_gravity(weight, launch, landing_str) do
  		case Helpers.get_gravity_by_name(landing_str) do
  			{:ok, gravity} -> 
  				make_complex_calculation(weight, Map.put(launch, :landing, gravity))
  			{:error, _} ->
  				{:error, "Wrong planet name for LANDING in the route"}
  		end
  	end

  	defp make_complex_calculation(weight, %{:launch => launch_gravity, :landing => landing_gravity}) do
		landing_fuel = Enum.sum(make_simple_calculation(weight, landing_gravity, :landing, []))
		launch_fuel = Enum.sum(make_simple_calculation(weight + landing_fuel, launch_gravity, :launch, []))
		landing_fuel + launch_fuel
  	end

	defp make_simple_calculation(weight, _, _, acc) when weight <= 0 do
  		[-weight | acc ]
  	end

  	defp make_simple_calculation(weight, gravity, :launch, acc) do
  		launch_start = trunc(weight * gravity * @launch) - @launch_round
  		make_simple_calculation(launch_start, gravity, :launch, [launch_start | acc])
  	end

  	defp make_simple_calculation(weight, gravity, :landing, acc) do
  		landing_start = trunc(weight * gravity * @landing) - @landing_round
  		make_simple_calculation(landing_start, gravity, :landing, [landing_start | acc])
  	end

    defp check_one_transport([%{"by" => by} | _tail] = routes) do
      case Enum.filter(routes, fn %{"by" => tr} -> by != tr end) do
        [] ->
          {:ok, by}
        _ ->
          {:error, "Different spaceships: One only spaceship must be chosen for all routes!"}
      end
    end

end