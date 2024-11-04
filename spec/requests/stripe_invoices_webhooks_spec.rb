require 'rails_helper'

RSpec.describe 'StripeInvoicesWebhooks', type: :request do
  describe 'Create' do
    context 'Create' do
      let(:headers) do
        { 'Content-Type' => 'application/json' }
      end
      let(:payload) do
        {
          type: 'invoice.paid',
          data: {
            object: {
              subscription: 'sub_1MafgvFEQ7w2dQeZWyZFlD39'
            }
          }
        }
      end

      context 'Stripe Signature is not verified' do
        it 'returns a forbidden response' do
          post '/stripe_subscriptions', headers: headers, params: payload.to_json

          expect(response.status).to eq(403)
        end
      end

      context 'Stripe Signature is verified' do
        before do
          allow(Stripe::Webhook).to receive(:construct_event).and_return('dummy_event_type')
        end

        context 'when the subscription related to the invoice exists' do
          let!(:subscription) { create(:subscription, stripe_subscription_id: 'sub_1MafgvFEQ7w2dQeZWyZFlD39') }

          it 'returns a success response and updates the state to paid' do
            post '/stripe_invoices', headers: headers, params: payload.to_json

            expect(subscription.stripe_subscription_id).to eq('sub_1MafgvFEQ7w2dQeZWyZFlD39')
            expect(subscription.reload.state).to eq('paid')
            expect(response.status).to eq(200)
          end
        end

        context 'when subscription does not exist' do
          it 'returns no content response' do
            payload[:type] = 'invoice.created'

            post '/stripe_invoices', headers: headers, params: payload.to_json

            expect(response.status).to eq(204)
          end
        end
      end
    end
  end
end
