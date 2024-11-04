class StripeInvoicesWebhooksController < StripeWebhooksController
  def create
    head :no_content and return unless params[:type] == STRIPE_WEBHOOK_EVENTS[:invoice_paid]

    subscription = InvoiceHandler.new(invoice_params).set_subscription_to_paid_if_found

    head :no_content and return unless subscription.present?

    head(:ok)
  end

  private

  def invoice_params
    params.require(:data)[:object]
  end
end
