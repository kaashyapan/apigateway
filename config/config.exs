# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :apigateway, ApigatewayWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "PkN54+Nki9bylGWLK8iwgKUIB6sV5slfgbVMevdlLEZ6BpzAni/kM1yfuMJP0WQJ",
  render_errors: [view: ApigatewayWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Apigateway.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ex_aws,
  region: "us-east-1",
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}],
  secret_access_key: [
    {:system, "AWS_SECRET_ACCESS_KEY"},
    {:awscli, "default", 30}
  ]

config :ex_aws, :s3, region: "ap-south-1"

config :ex_aws, :sns, region: "us-east-1"

config :apigateway, ApigatewayWeb.FormSubmit.Mailer,
  adapter: Bamboo.SesAdapter,
  ex_aws: [
    region: "us-east-1"
  ]
