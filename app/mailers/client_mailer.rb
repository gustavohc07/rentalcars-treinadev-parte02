class ClientMailer < ApplicationMailer
  default from:'registration@rentalcars.com.br'

  def welcome_email(client_id)
    @client = IndividualClient.find(client_id)
    mail(to: @client.email)
  end
end