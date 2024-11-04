class InvoiceHandler
  attr_reader :subscription

  def initialize(stripe_invoice_params)
    @invoice_params = stripe_invoice_params
  end

  def set_subscription_to_paid_if_found
    fetch_subscription

    return unless subscription.present?

    subscription.update(state: 'paid')
  end

  private

  def fetch_subscription
    @subscription = Subscription.find_by(stripe_subscription_id: @invoice_params[:subscription])
  end
end
