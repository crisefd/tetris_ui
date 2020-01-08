defmodule TetrisUiWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.Brick

  def mount(_session, socket) do
    {
      :ok,
      assign(socket,
            tetromino: Brick.new(:random) |> Brick.to_string())
    }
  end

  def render(assigns) do
    ~L""" 
    <h1>Tetromino</h1>
    <pre>
      <%= @tetromino %>
    </pre>
    """
  end
end