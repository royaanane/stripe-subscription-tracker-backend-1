Rails Stripe Event Processor
A simple Rails application for processing Stripe subscription events, created as part of a coding challenge in February of 2023. The project is not maintained.

Overview
This application handles the following Stripe events:

Subscription Creation: When a new subscription is created in Stripe, a corresponding record is saved in the database with an initial status of unpaid.
Invoice Payment: When the first invoice is marked as paid, the application updates the subscription status from unpaid to paid.
Features
Subscription Management: Automatically tracks subscription creation and updates status upon payment.
Webhook Integration: Listens for Stripe webhooks to manage subscriptions and invoices in real-time.
Test Coverage: Includes tests to validate the subscription flow from creation to payment.
Setup Instructions
Prerequisites
Rails: Ensure you have Rails installed.
Stripe Account: Create a free Stripe account and enable Test Mode to simulate subscription events.
Stripe CLI: Install the Stripe CLI to forward Stripe events to your local environment.
Getting Started
Clone the Repository:

bash
Copier le code
git clone <repository-url>
cd rails-stripe-event-processor
Environment Variables: Create an .env file in the root directory with the following variables:

STRIPE_SIGNIN_SECRET: Your Stripe webhook signing secret.
Any other required keys for your setup.
Install Dependencies:

bash
Copier le code
bundle install
Database Setup:

bash
Copier le code
rails db:create
rails db:migrate
Running the Application
Start the Server:

bash
Copier le code
rails server -p 3000
Setup Stripe Webhooks: In two separate terminal tabs, run the following to listen for events:

bash
Copier le code
stripe listen --events=customer.subscription.created --forward-to localhost:3000/stripe_subscriptions
stripe listen --events=invoice.paid --forward-to localhost:3000/stripe_invoices
Create and Manage Subscriptions:

Use the Stripe Test Dashboard to create a subscription.
Set the invoice status as "Paid" in the Invoices Dashboard.
The application will update the subscription status from unpaid to paid in response to the paid invoice event.
Testing
Run tests to verify the subscription creation and payment flow:

bash
Copier le code
rails test
Notes
In scenarios where both subscription and invoice events occur simultaneously (such as auto-charged payment methods), the application may receive events out of order. Further discussion or handling strategies could address this behavior.
