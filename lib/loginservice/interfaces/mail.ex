defmodule Loginservice.Interfaces.Mail do
  def send_mail(to, subject, content, content_type \\ "text/plain") do
    mail_service = Application.get_env(:loginservice, Loginservice.Interfaces.Mail)[:mail_service]
    apply(Loginservice.Interfaces.Mail, mail_service, [to, subject, content, content_type])
  end

  def sendgrid(to, subject, content, content_type) do
    data = %{
      personalizations: [%{
        to: [%{email: to}],
        subject: subject
      }],
      from: %{email: Application.get_env(:loginservice, Loginservice.Interfaces.Mail)[:from]}, 
      content: [%{
        type: content_type,
        value: content
      }]
    }

    HTTPoison.post("https://api.sendgrid.com/v3/mail/send", Poison.encode!(data) |> IO.inspect, [{"Authorization", "Bearer " <> Application.get_env(:loginservice, Loginservice.Interfaces.Mail)[:sendgrid_key]}, {"Content-Type", "application/json"}])
  end

  def consoleout(to, subject, content, content_type) do
    #IO.inspect("to:  " <> to)
    #IO.inspect("sub: " <> subject)
    #IO.inspect("content: " <> content)
    #IO.inspect("content_type: " <> content_type)

    # Save in ets so test can query it
    :ets.insert(:saved_mail, {to, subject, content, content_type})
  end
end