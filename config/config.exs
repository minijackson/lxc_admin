# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lxc_admin,
  namespace: LXCAdmin,
  ecto_repos: [LXCAdmin.Repo]

# Configures the endpoint
config :lxc_admin, LXCAdmin.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7wrPMtNXZNMIbNoowt9XC12va9wkaABi0lpaV+WDxoKMAJTnLQXRjBNyfT8PWcf2",
  render_errors: [view: LXCAdmin.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LXCAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
