require 'rails_helper'

RSpec.describe 'StripeSubscriptionsWebhooks', type: :request do
  describe 'Create' do
    let(:headers) do
      { 'Content-Type' => 'application/json' }
    end
    let(:payload) do
      {
        type: 'customer.subscription.created',
        data: {
          object: {
            id: 'sub_1MafgvFEQ7w2dQeZWyZFlD39',
            object: 'subscription'
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

      context 'when request is valid' do
        it "returns success response and creates a subscription record with the state as 'unpaid'" do
          post '/stripe_subscriptions', headers: headers, params: payload.to_json

          expect(response.status).to eq(201)
          expect(Subscription.find_by(stripe_subscription_id: 'sub_1MafgvFEQ7w2dQeZWyZFlD39',
                                      state: 'unpaid')).to be_present
        end
      end

      context 'when a different event than subscription creation is received' do
        it 'returns a no content response' do
          payload[:type] = 'invoice.paid'

          post '/stripe_subscriptions', headers: headers, params: payload.to_json

          expect(response.status).to eq(204)
        end
      end
    end
  end
end
