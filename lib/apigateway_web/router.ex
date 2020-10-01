defmodule ApigatewayWeb.Router do
  use ApigatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/api", ApigatewayWeb do
    pipe_through :api
    post "/formsubmit1", FormController1, :submit1
    post "/formsubmit", FormController, :submit
    get "/awsv4", UploadServiceController, :awsv4
  end

  scope "/", ApigatewayWeb do
    pipe_through([:browser])
    get "/getfile/:file_name", UploadServiceController, :getfile
  end
end
