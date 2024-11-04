class StripeWebhooksController < ActionController::Base
  before_action :check_stripe_signature

  private

  def check_stripe_signature
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    signin_secret = ENV['STRIPE_SIGNIN_SECRET']

    begin
      Stripe::Webhook.construct_event(payload, signature_header, signin_secret)
    rescue JSON::ParserError
      head :forbidden
    rescue Stripe::SignatureVerificationError
      head :forbidden
    end
  end
end
