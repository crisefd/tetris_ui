defmodule TetrisUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :tetris_ui,
      version: "0.1.0",
      elixir: ">= 1.9.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TetrisUi.Application, []},
      extra_applications: [:logger, :runtime_tools, :tetris]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix_live_view, "~> 0.15.4"},
      {:floki, ">= 0.27.0", only: :test},
      {:mock, "~> 0.3.4", only: :test},
      {:tetris, git: "https://github.com/crisefd/tetris"},
      {:dialyxir, git: "https://github.com/jeremyjh/dialyxir", only: [:dev], runtime: false},
    ]
  end
end
