defmodule FuelCalcWeb.FcControllerTest do
  use FuelCalcWeb.ConnCase

  require Logger

  setup do
    :ok
  end

  test "route to define_routes page", %{conn: conn} do
    new_conn = get(conn, Routes.fc_path(conn, :define_routes))

    assert html_response(new_conn, 200) =~ "PUSH here to select the routes:"
  end

  test "calculate empty routes", %{conn: conn} do
    routes = [""]
    new_conn = post(conn, Routes.fc_path(conn, :calculate, %{"routes" => routes}))

    assert Map.get(new_conn.private, :phoenix_flash) == %{"error" => "Empty routes"}

    assert html_response(new_conn, 302) =~ "/fuel"
  end

  test "calculate correct routes", %{conn: conn} do
    routes = correct_routes()
    result = 51_898
    new_conn = post(conn, Routes.fc_path(conn, :calculate, %{"routes" => routes}))

    assert html_response(new_conn, 200) =~ "Results of calculated fuel amount for route(-s):"

    new_cache_conn = post(conn, Routes.fc_path(conn, :calculate, %{"routes" => routes}))
    assert Map.get(new_cache_conn.assigns, :result) == result
  end

  test "calculate the same launch_landing route", %{conn: conn} do
    routes = incorrect_routes_the_same()
    new_conn = post(conn, Routes.fc_path(conn, :calculate, %{"routes" => routes}))

    assert Map.get(new_conn.private, :phoenix_flash) == %{
             "error" => "Wrong destination: Launch planet and landing planet are the SAME"
           }

    assert html_response(new_conn, 302) =~ "/fuel"
  end

  test "calculate different transport routes", %{conn: conn} do
    routes = diff_transport_routes()
    new_conn = post(conn, Routes.fc_path(conn, :calculate, %{"routes" => routes}))

    assert Map.get(new_conn.private, :phoenix_flash) == %{
             "error" => "Different spaceships: One only spaceship must be chosen for all routes!"
           }

    assert html_response(new_conn, 302) =~ "/fuel"
  end

  test "show result", %{conn: conn} do
    new_conn = get(conn, Routes.fc_path(conn, :result, 51_898))

    assert html_response(new_conn, 200) =~ "Results of calculated fuel amount for route(-s):"
  end

  defp correct_routes do
    [
      "",
      %{"by" => "Apollo_11"},
      %{"launch" => "Earth"},
      %{"landing" => "Moon"},
      %{"by" => "Apollo_11"},
      %{"launch" => "Moon"},
      %{"landing" => "Earth"}
    ]
  end

  defp incorrect_routes_the_same do
    [
      "",
      %{"by" => "Apollo_11"},
      %{"launch" => "Earth"},
      %{"landing" => "Moon"},
      %{"by" => "Apollo_11"},
      %{"launch" => "Earth"},
      %{"landing" => "Earth"}
    ]
  end

  defp diff_transport_routes do
    [
      "",
      %{"by" => "Apollo_11"},
      %{"launch" => "Earth"},
      %{"landing" => "Moon"},
      %{"by" => "Passenger_Ship"},
      %{"launch" => "Earth"},
      %{"landing" => "Earth"}
    ]
  end
end
