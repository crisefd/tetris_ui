defmodule TetrisUiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use TetrisUiWeb, :controller
      use TetrisUiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt uploads)

  def controller do
    quote do
      use Phoenix.Controller, namespace: TetrisUiWeb
      import Plug.Conn
      import TetrisUiWeb.Gettext
      alias TetrisUiWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Controller
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {TetrisUiWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  # def view do
  #   quote do
  #     use Phoenix.View,
  #       root: "lib/tetris_ui_web/templates",
  #       namespace: TetrisUiWeb

  #     # Import convenience functions from controllers
  #     import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

  #     # Use all HTML functionality (forms, tags, etc)
  #     use Phoenix.HTML

  #     import TetrisUiWeb.ErrorHelpers
  #     import TetrisUiWeb.Gettext
  #     alias TetrisUiWeb.Router.Helpers, as: Routes

  #     import Phoenix.Component
  #   end
  # end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TetrisUiWeb.Gettext
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import TetrisUiWeb.Gettext

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: TetrisUiWeb.Endpoint,
        router: TetrisUiWeb.Router,
        statics: TetrisUiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
