defmodule TetrisUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Phoenix.PubSub

  use Application

  @impl true
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      TetrisUiWeb.Endpoint,
      {PubSub, [name: TetrisUi.PubSub, adapter: PubSub.PG2]}
      # Starts a worker by calling: TetrisUi.Worker.start_link(arg)
      # {TetrisUi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TetrisUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TetrisUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
