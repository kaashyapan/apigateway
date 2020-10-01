defmodule ApigatewayWeb.FormController1 do
  use ApigatewayWeb, :controller

  alias ApigatewayWeb.FormSubmit.Sendmail1

  action_fallback(ApigatewayWeb.FallbackController)

  def submit1(conn, params) do
    IO.inspect(conn.req_headers)
    IO.inspect(params)

    Task.async(Sendmail1, :send_emails, [params])
    json(conn, params)
  end

end
