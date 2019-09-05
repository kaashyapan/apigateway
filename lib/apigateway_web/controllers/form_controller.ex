defmodule ApigatewayWeb.FormController do
  use ApigatewayWeb, :controller

  alias ApigatewayWeb.FormSubmit.Sms
  alias ApigatewayWeb.FormSubmit.Sendmail

  action_fallback(ApigatewayWeb.FallbackController)

  def submit(conn, params) do
    source =
      Enum.filter(conn.req_headers, fn {k, _v} -> k == "origin" || k == "referer" end)
      |> List.first()
      |> case do
        {_, src} ->
          re = ~r/(?<domain>(\w*\.\w*)+)/
          %{"domain" => domain} = Regex.named_captures(re, src)
          domain

        _ ->
          "unknown"
      end

    with {:ok, _} <- filter_honeypot(params),
         {:ok, to_email, ph} <- get_host_params(source) do
      Task.async(Sendmail, :send_emails, [source, to_email, params])
      Task.async(Sms, :send_sms, [source, ph, params])
      #Sendmail.send_emails(source, to_email, params)
      #Sms.send_sms(source, ph, params)
      json(conn, params)
    else
      {:error, _} ->
        conn
        |> put_status(:not_found)
        |> put_view(ApigatewayWeb.ErrorView)
        |> render("404.json")
    end
  end

  def get_host_params(host) when host == "www.nangiarkoothu.com" or host == "nangiarkoothu.com" do
    {:ok, ["aparnanangiar@nangiarkoothu.com"], ["+919447313864"]}
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
  end

  def get_host_params(host) when host == "www.gopalamurugan.com" or host == "gopalamurugan.com" do
    {:ok, ["secretary@gopalamurugan.com"], ["+918056088898"]}
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
  end

  def get_host_params(host)
      when host == "www.vibgyorhealthcare.com" or host == "vibgyorhealthcare.com" do
    {:ok, ["customercare@vibgyorhealthcare.com"], ["+919384606891"]}
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
  end

  def get_host_params(host)
      when host == "www.treatmyaneurysm.com" or host == "treatmyaneurysm.com" do
    {:ok, ["support@treatmyaneurysm.com"], ["+919820078932"]}
  end

  def get_host_params(_host) do
    {:ok, ["vichitraveeryan@gmail.com"], ["+919962048595"]}
  end

  def filter_honeypot(params) do
    Map.fetch(params, "_honey")
    |> case do
         {:ok, nil} ->
           {:ok, "nohoney"}
         {:ok, x} ->
           if String.length(x) > 0 do
             {:error, x}
           else
             {:ok, "nohoney"}
           end
         _ -> {:ok, "nohoney"}
    end
  end
end
