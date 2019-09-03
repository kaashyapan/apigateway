defmodule ApigatewayWeb.FormSubmit.Sms do

  alias ExAws.SNS

  def send_sms(host, ph, _clean_params) do
    message_attributes = [
      %{name: "AWS.SNS.SMS.SenderID", data_type: :string, value: {:string, "sender"}},
      %{name: "AWS.SNS.SMS.SMSType", data_type: :string, value: {:string, "Transactional"}}
    ]

    message = "You have received a message on " <> host

    Enum.map(ph, fn phone_no ->

      IO.inspect phone_no
      
      SNS.publish(message,
        message_attributes: message_attributes,
        phone_number: phone_no
      )
      |> ExAws.request(region: "us-east-1")
      |> IO.inspect()
    end)
  end
end
