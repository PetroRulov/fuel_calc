defmodule FuelCalcWeb.FcController do
  use FuelCalcWeb, :controller

  alias FuelCalc.FcServer

  require Logger

  def calculate(conn, %{"routes" => aux_routes}) do
  	[_ | def_routes] = aux_routes
  	routes = Enum.map(Enum.chunk_every(def_routes, 3), fn [by, launch, landing] ->
        Map.merge(by, Map.merge(launch, landing)) end)
    case FcServer.calculate(routes) do
    	{:ok, %{fuel: fuel, msg: msg}} ->
    		conn
    		|> put_flash(:info, msg)
    		|> render("action.html", fuel: fuel, mark: "result")
    	{:error, message} ->
    		conn
    		|> put_flash(:error, message)
    		|> redirect(to: Routes.fc_path(conn, :define_routes))
    end    
  end

  def define_routes(conn, _) do
	routes = %{:by => nil, :launch => nil, :landing => nil}
    render(conn, "action.html", routes: routes, mark: "new_routes")
  end

  def result(conn, %{fuel: fuel}) do
  	render(conn, "results.html", fuel: fuel)
  end

end