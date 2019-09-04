defmodule ApigatewayWeb.FormController do
  use ApigatewayWeb, :controller

  alias ApigatewayWeb.FormSubmit.Sms
  alias ApigatewayWeb.FormSubmit.Sendmail

  action_fallback(ApigatewayWeb.FallbackController)

  def submit(conn, params) do
    with {:ok, to_email, ph} <- get_host_params(conn.host),
         {:ok, _} <- filter_honeypot(params) do
      IO.inspect conn
     # {_, source} =
     #   Enum.filter(conn.req_headers, fn {k, v} -> k == "x-forwarded-for" end)
     #   |> List.first
     # Sendmail.send_emails(source, to_email, params)
     # Sms.send_sms(source, ph, params)
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
    {:ok, ["aparnanangiar@nangiarkoothu.com"], ["+919447313864"]}
  end

  def get_host_params(host = "gopalamurugan.com") do
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
    # {:ok, ["secretary@gopalamurugan.com"], ["+918056088898"]}
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
