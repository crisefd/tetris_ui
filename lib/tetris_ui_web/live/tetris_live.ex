defmodule TetrisUiWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  def mount(_session, socket) do
    {
      :ok,
      assign(socket, hello: :hi, name: :chris)
    }
  end

  def render(assigns) do
    ~L""" 
    <h1><%= @hello %> <%= @name %></h1>
    """
  end
end