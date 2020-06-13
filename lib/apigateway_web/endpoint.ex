defmodule ApigatewayWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :apigateway

  socket "/socket", ApigatewayWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :apigateway,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug CORSPlug,
    origin: ~r/.*/,
    headers: ["x-api-key" | CORSPlug.defaults[:headers]]
    origin: ~r/.*/

  plug Plug.Session,
    store: :cookie,
    key: "_apigateway_key",
    signing_salt: "eqDhb8Lm"

  plug ApigatewayWeb.Router
end
