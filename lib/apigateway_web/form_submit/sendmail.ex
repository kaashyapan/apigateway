defmodule ApigatewayWeb.FormSubmit.Sendmail do
  use Bamboo.Phoenix, view: ApigatewayWeb.FormView
  alias ApigatewayWeb.FormSubmit.Mailer
 
  def send_emails(host, to_, form_) do
    new_email()
    |> from("noreply@kaashyapan.com")
    |> put_to(to_)
    |> bcc("vichitraveeryan.gmail.com")
    |> put_subject(host, form_)
    |> put_reply_to(form_)
    |> put_assigns(form_)
    |> render(:email)
    |> Mailer.deliver_later()
  end

  defp put_subject(mail, host, form_) do
    sub =
      case Map.fetch(form_, "subject") do
        {:ok, sub_} -> sub_
        _ -> "Message from " <> host
      end

    subject(mail, sub)
  end

  defp put_assigns(mail, form_) do
    form_params = filter_params(form_)
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

  defp put_reply_to(mail, form_) do
    case Map.fetch(form_, "email") do
      {:ok, reply_to_id} ->
        put_header(mail, "Reply-To", reply_to_id)

      _ ->
        mail
    end
  end

  defp put_to(mail, to_) do
    {_, to_mail} =
      Enum.map_reduce(
        to_,
        mail,
        fn to_address, mail -> {to_address, to(mail, to_address)} end
      )

    to_mail
  end
end
