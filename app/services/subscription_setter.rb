class SubscriptionSetter
  def initialize(stripe_subscription_params)
    @subscription_params = stripe_subscription_params
  end

  def call
    Subscription.create(stripe_subscription_id: @subscription_params[:id], state: 'unpaid')
  end
end
