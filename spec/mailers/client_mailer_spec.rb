require 'rails_helper'
  RSpec.describe ClientMailer do
    describe "#welcome_email" do
      it 'should send to client email' do
        client = create(:individual_client, email: 'teste@email.com')
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.to).to include(client.email)

      end

      it 'should send from default email' do
        client = create(:individual_client,  email: 'teste@email.com')
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.from).to include('registration@rentalcars.com.br')
      end

      it 'should have correct subject' do
        client = create(:individual_client, name: 'Joãozinho da Silva', email: 'teste@email.com')
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.subject).to include("Caro #{client.name} seu registro foi concluído com sucesso")
      end

      it 'should have correct body' do
        client = create(:individual_client, name: 'Joãozinho da Silva', email: 'teste@email.com')
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.body).to include("Seja bem vindo, #{client.name}! Ative o sininho para receber notificações!")
      end

    end
    
    
  end
  