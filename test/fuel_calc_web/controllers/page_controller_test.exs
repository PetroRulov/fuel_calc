defmodule FuelCalcWeb.PageControllerTest do
  use FuelCalcWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<!DOCTYPE html>\n<html lang=\"en\">\n"
  end
end
