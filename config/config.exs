# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tetris_ui, TetrisUiWeb.Endpoint,
 live_view: [
     signing_salt: "EeUoHSopUOP24b2/OkVJpRmcmKGRkcMm"
  ],
  url: [host: "localhost"],
  secret_key_base: "W0c7STjuqYHZ6cbZq9tPEc/5WouCts4ciVyPrSrsRbi1hbZj1FPtSci+KKmTDGLr",
  render_errors: [view: TetrisUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TetrisUi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"