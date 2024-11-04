class StripeProcessor
  require 'stripe'

  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
end
