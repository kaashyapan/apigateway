defmodule ApigatewayWeb.FormController2 do
  use ApigatewayWeb, :controller

  alias ApigatewayWeb.FormSubmit.Sendmail2

  action_fallback(ApigatewayWeb.FallbackController)

  def submit2(conn, params) do
    IO.inspect(conn.req_headers)
    IO.inspect(params)

    Task.async(Sendmail2, :send_emails, [params])
    json(conn, params)
  end

end
