class StripeSubscriptionsWebhooksController < StripeWebhooksController
  def create
    head :no_content and return unless params[:type] == STRIPE_WEBHOOK_EVENTS[:subscription_created]

    SubscriptionSetter.new(subscription_params).call

    head(:created)
  end

  private

  def subscription_params
    params.require(:data)[:object]
  end
end
