class ChargesController < ApplicationController

  def new
  end

  def create
    # Amount in cents
    @amount = 999

    customer = Stripe::Customer.create(
        :email => current_user.email,
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Unlimited Plan',
        :currency    => 'usd'
    )

  def subscribe
    customer = Stripe::Customer.retrieve(CUSTOMER_ID)
    customer.subscriptions.create({:plan => PLAN_ID})
  end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

end
