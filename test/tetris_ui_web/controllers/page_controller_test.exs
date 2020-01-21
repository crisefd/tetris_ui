defmodule TetrisUiWeb.PageControllerTest do
  use TetrisUiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Tetris"
  end
end
