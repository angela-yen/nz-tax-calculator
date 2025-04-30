require 'rails_helper'

RSpec.describe NzTaxCalculatorController, type: :controller do
  render_views

  # Testing the GET correctly renders the index page
  describe 'GET #index' do
    it 'renders the index template with a 200 status' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end
  end

  # Testing the Post correctly calculates the tax amount and breakdown 
  describe 'POST #calculate' do
    shared_examples 'correct tax calculated and tax breakdown' do
      context 'when valid income is provided' do
        it 'calculates the tax and includes tax amount in the response' do
          post :calculate, params: { income: annual_income_value }

          expect(response.status).to eq(200)
          expect(response.body).to include("Tax Amount:")
          expect(response.body).to include(tax_amount)
        end

        it 'calculates the tax breakdown correctly' do
          post :calculate, params: { income: annual_income_value }

          expect(response.body).to include('Tax Breakdown')

          expect(response.body).to include('Bracket')
          expect(response.body).to include('Rate')

          expect(response.body).to include(tax_amount)
        end
      end
    end

    context 'when valid income of $10000 is provided' do
      let(:annual_income_value) { 10000 }
      let(:tax_amount) { "$1050.00" }

      it_behaves_like 'correct tax calculated and tax breakdown'
    end

    context 'when valid income of $35000 is provided' do
      let(:annual_income_value) { 35000 }
      let(:tax_amount) { "$5033.00" }

      it_behaves_like 'correct tax calculated and tax breakdown'
    end

    context 'when valid income of $100000 is provided' do
      let(:annual_income_value) { 100000 }
      let(:tax_amount) { "$22877.50" }

      it_behaves_like 'correct tax calculated and tax breakdown'
    end

    context 'when valid income of $220000 is provided' do
      let(:annual_income_value) { 220000 }
      let(:tax_amount) { "$64877.50" }

      it_behaves_like 'correct tax calculated and tax breakdown'
    end

    context 'when income is zero' do
      it 'returns a tax amount of 0.00' do
        post :calculate, params: { income: 0 }

        expect(response.status).to eq(200)
        expect(response.body).to include("Tax Amount:")
        expect(response.body).to include("$0.00")
      end
    end
  end
end