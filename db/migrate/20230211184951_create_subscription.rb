class CreateSubscription < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :state
      t.string :stripe_subscription_id

      t.timestamps
    end
  end
end
