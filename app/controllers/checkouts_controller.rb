class CheckoutsController < ApplicationController
  # Only authorized users can call this controller
  before_action :authenticate_user!

  # To set up the secret key in the credentials file, type in:
  # VISUAL="code --wait" bin/rails credentials:edit

  # Get the secret key from the file
  stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)

  # Add the secret key to stripe key here
  Stripe.api_key = stripe_secret_key

  def create
    # Find course
    course = Course.find(params[:course_id])

    # Create a Stripe checkout session
    # Test card is 4242 4242 4242 4242
    session = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: [{
        price: course.stripe_price_id,
        quantity: 1
      }],
      success_url: request.base_url + "/courses/#{course.id}",
      cancel_url:  request.base_url + "/courses/#{course.id}",
      # automatic_tax: { enabled: true },
      customer_email: current_user.email,
      metadata: { course_id: course.id }
    )

    # Redirect back
    redirect_to session.url, allow_other_host: true
  end
end
