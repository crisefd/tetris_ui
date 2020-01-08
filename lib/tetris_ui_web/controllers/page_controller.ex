defmodule TetrisUiWeb.PageController do
  use TetrisUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
