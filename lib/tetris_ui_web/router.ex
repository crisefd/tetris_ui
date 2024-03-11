defmodule TetrisUiWeb.Router do
  use TetrisUiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, html: {TetrisUiWeb.Layouts, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TetrisUiWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/tetris", TetrisLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TetrisUiWeb do
  #   pipe_through :api
  # end
end
