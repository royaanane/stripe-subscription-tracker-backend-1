class Subscription < ApplicationRecord
  SUBSCRIPTION_STATES = {
    unpaid: 0,
    paid: 1
  }.freeze

  enum state: SUBSCRIPTION_STATES

  validates :state, inclusion: { in: SUBSCRIPTION_STATES.keys.map(&:to_s) }
end
