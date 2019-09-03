defmodule ApigatewayWeb.Router do
  use ApigatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApigatewayWeb do
    pipe_through :api
    post "/formsubmit", FormController, :submit
  end
end
