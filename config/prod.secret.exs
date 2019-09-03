# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

secret_key_base =
  "wA+tO6BGOylR0EBXT3CyxVCc0jUJ4IcKucHswZzzRXrqOW4dJb6NFg8GXu+BknB8"

config :apigateway, ApigatewayWeb.Endpoint,
  http: [host: "0.0.0.0", port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base
