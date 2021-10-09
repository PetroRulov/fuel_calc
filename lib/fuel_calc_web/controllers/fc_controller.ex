defmodule FuelCalcWeb.FcController do
  use FuelCalcWeb, :controller

  alias FuelCalc.FcCacher
  alias FuelCalc.Service.FcServer

  require Logger

  def calculate(conn, %{"routes" => aux_routes}) do
    [_ | def_routes] = aux_routes

    routes =
      Enum.map(
        Enum.chunk_every(def_routes, 3),
        fn [by, launch, landing] ->
          Map.merge(by, Map.merge(launch, landing))
        end
      )

    case FcCacher.get(routes) do
      nil ->
        calculate_routes(conn, routes)

      {%{fuel: fuel}, msg} ->
        conn
        |> put_flash(:info, msg)
        |> render("action.html", result: fuel, mark: "result")
    end
  end

  def define_routes(conn, _) do
    routes = %{by: nil, launch: nil, landing: nil}
    render(conn, "action.html", routes: routes, mark: "new_routes")
  end

  def result(conn, %{"result" => result}) do
    render(conn, "results.html", %{result: result})
  end

  defp calculate_routes(conn, routes) do
    case FcServer.calculate(routes) do
      {:ok, {%{fuel: fuel}, msg}} ->
        conn
        |> put_flash(:info, msg)
        |> render("action.html", result: fuel, mark: "result")

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.fc_path(conn, :define_routes))
    end
  end
end
