class WebhooksController < ApplicationController
  # Allows this to be called across origin 
  skip_forgery_protection

  # This handles the Stripe webhook
  def stripe
    # Get my secret key
    stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
    # Set Stripe gem up with the secret key
    Stripe.api_key = stripe_secret_key

    # Get the payload off the body
    payload = request.body.read
    # Get the header value for Stripe signature
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    # Take the webhook secret from credentials
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    event = nil

    # Begin-rescue block for catching some errors
    begin
      # Construct the event
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)

    rescue JSON::ParserError => e # Something bad with the payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e # Signature not valid
      puts "Webhook signature verification failed."
      status 400
      return
    end

    # Case-when block for checking for different types
    case event.type
    # 
    when "checkout.session.completed"
      
      # Extract session object from event data
      session = event.data.object
      
      # Call stripe API to get all data that we need
      full_session = Stripe::Checkout::Session.retrieve({
        id: session.id,
        expand: ['line_items']
      })

      # Get the line items
      line_items = full_session.line_items

      puts "session #{session}"
      puts "line_items #{line_items}"

      course_id = session.metadata.course_id
      course = Course.find(course_id)
      user = User.find_by!(email: session.customer_email)

      # New model that tracks if user has bought the course
      # If a record exists, they have bought it
      CourseUser.create!(course: course, user: user)
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: 'success' }
  end
end
