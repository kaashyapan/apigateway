defmodule ApigatewayWeb.Router do
  use ApigatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApigatewayWeb do
    pipe_through :api
    post "/formsubmit", FormController, :submit
    get "/awsv4", UploadServiceController, :awsv4
    get "/getfile/:file_name", UploadServiceController, :getfile
    get "/gettorrent/:file_name", UploadServiceController, :gettorrent
  end
end
