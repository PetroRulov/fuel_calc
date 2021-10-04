defmodule FuelCalcWeb.PageController do
  use FuelCalcWeb, :controller

  def index(conn, _params) do
  	render(conn, "index.html")
  end

end
