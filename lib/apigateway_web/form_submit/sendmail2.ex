defmodule ApigatewayWeb.FormSubmit.Sendmail2 do
  use Bamboo.Phoenix, view: ApigatewayWeb.FormView
  alias ApigatewayWeb.FormSubmit.Mailer

  def send_emails(form_) do
    new_email()
    |> put_from(form_)
    #|> from("noreply@kaashyapan.com")
    |> put_to(form_)
    |> bcc("vichitraveeryan@gmail.com")
    |> put_subject(form_)
    |> put_to(form_)
    |> put_reply_to(form_)
    |> put_assigns(form_)
    |> render(:email)
    |> Mailer.deliver_later()
  end

  defp remove_key_seq(f) do
    for {k, v} <- f, into: %{} do
      {remove_seq_from_string(k), v}
    end
  end

  def remove_seq_from_string(str) do
    Integer.parse(str)
    |> case do
      {i, rest} when is_integer(i)-> String.trim_leading(rest, "_")
      _ -> str
    end
  end

  defp put_subject(mail, form_) do
    sub =
      form_
      |> remove_key_seq()
      |> Map.fetch!("subject")

    subject(mail, sub)
  end

  defp put_assigns(mail, form_) do
    form_params = form_ |> filter_params()
    assign(mail, :form, form_params)
  end

  defp filter_params(params) do
    keys =
      params
      |> Map.keys()
      |> Enum.filter(fn x -> String.first(x) == "_" end)

    params
    |> Map.drop(keys)
    |> Map.to_list()
    |> Enum.sort(fn {k1, _}, {k2, _} -> k1 <= k2 end)
    |> Enum.map(fn {k, v} -> {remove_seq_from_string(k), v} end)
    |> Enum.reject(fn {k, _} -> k == "subject" or k == "Subject" end)
    |> Enum.map(fn {k, v} -> {String.capitalize(k), v} end)
    end

  defp put_reply_to(mail, form_) do
    form_ = remove_key_seq(form_)
    case Map.fetch(form_, "email") do
      {:ok, reply_to_id} ->
        put_header(mail, "Reply-To", reply_to_id)

      _ ->
        mail
    end
  end

  defp put_to(mail, form_) do
    form_ = remove_key_seq(form_)
    to_list = form_["_to_mail"] |> String.split(";")
    to(mail, to_list)
  end

  defp put_from(mail, form_) do
    form_ = remove_key_seq(form_)
    from(mail, form_["_from_mail"])
  end
end
