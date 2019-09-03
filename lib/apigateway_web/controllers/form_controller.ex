defmodule ApigatewayWeb.FormController do
  use ApigatewayWeb, :controller

  alias ApigatewayWeb.FormSubmit.Sms
  alias ApigatewayWeb.FormSubmit.Sendmail

  action_fallback(ApigatewayWeb.FallbackController)

  def submit(conn, params) do
    with {:ok, to_email, ph} <- get_host_params(conn.host),
         {:ok, _} <- filter_honeypot(params) do
      Sendmail.send_emails(conn.host, to_email, params)
      Sms.send_sms(conn.host, ph, params)
      json(conn, params)
    else
      {:error, _} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApigatewayWeb.ErrorView)
        |> render("404.json")
    end
  end

  def get_host_params(host = "nangiarkoothu.com") do
    {:ok, ["aparnanangiar@nangiarkoothu.com"], ["+919962048595", "+919447313864"]}
  end

  def get_host_params(host = "gopalamurugan.com") do
    {:ok, ["secretary@gopalamurugan.com"], ["+918056088898"]}
  end

  def get_host_params(host = "vibgyorhealthcare.com") do
    {:ok, ["customercare@vibgyorhealthcare.com"], ["+919384606891"]}
  end

  def get_host_params(host = "treatmyaneurysm.com") do
    {:ok, ["support@treatmyaneurysm.com"], ["+919820078932"]}
  end

  def get_host_params(_host) do
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
  end

  def filter_honeypot(params) do
    Map.fetch(params, "_honey")
    |> case do
      {:ok, x} -> {:error, x}
      _ -> {:ok, "nohoney"}
    end
  end
end
