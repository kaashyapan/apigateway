defmodule ApigatewayWeb.FormSubmit.Sendmail1 do
  use Bamboo.Phoenix, view: ApigatewayWeb.FormView
  alias ApigatewayWeb.FormSubmit.Mailer

  def send_emails(form_) do
    new_email()
    |> from("noreply@kaashyapan.com")
    |> put_to(form_)
    |> bcc("vichitraveeryan@gmail.com")
    |> put_subject(form_)
    |> put_to(form_)
    |> put_reply_to(form_)
    |> put_assigns(form_)
    |> render(:email)
    |> Mailer.deliver_later()
  end

  defp put_subject(mail, form_) do
    sub = Map.fetch!(form_, "subject")
    subject(mail, sub)
  end

  defp put_assigns(mail, form_) do
    form_params = form_ |> filter_params() |> prettify_params()
    assign(mail, :form, form_params)
  end

  defp filter_params(params) do
    keys =
      params
      |> Map.keys()
      |> Enum.filter(fn x -> String.first(x) == "_" end)

    params
    |> Map.drop(keys)
    |> Map.drop(["subject"])
  end

  defp prettify_params(params) do
    Enum.map(params, fn {k, v} -> {String.capitalize(k), v} end)
  end

  defp put_reply_to(mail, form_) do
    case Map.fetch(form_, "email") do
      {:ok, reply_to_id} ->
        put_header(mail, "Reply-To", reply_to_id)

      _ ->
        mail
    end
  end

  defp put_to(mail, form_) do
    to(mail, form_["_to_mail"])
  end
end
