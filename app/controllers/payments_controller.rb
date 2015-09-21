class PaymentsController < ApplicationController
	before_filter :authenticate_user!
	require "stripe"

	def index
		
	end

	def new
		@payment = Payment.new
		if params[:plan_id].present?
			@plan = Plan.find(params[:plan_id])

		end
	end

	def create
		Stripe.api_key = GlobalConstants::STRIPE_KEY
		
		if params[:payment][:plan_id].present?
			uniqueId  = Plan.find(params[:payment][:plan_id]).plan_type
			@response = Stripe::Customer.create(
			  :card => params[:payment][:token], # obtained with Stripe.js
			  :plan=> uniqueId
			)
		else
			@response = Stripe::Customer.create(
			  :card => params[:payment][:token] # obtained with Stripe.js
			)
		end
		payment = current_user.payment || current_user.build_payment
		payment.token = params[:payment][:token]
		payment.customer_id = @response["id"]
		payment.subscription_id = @response["subscriptions"]["data"][0]["id"] if @response["subscriptions"].present? && @response["subscriptions"]["data"].present?
		
		num_str = params[:payment][:card_number]
		payment.card_number = num_str[-4..-1]
		payment.card_code = params[:payment][:card_code]
		payment.plan_id = params[:payment][:plan_id] if params[:payment][:plan_id].present?
		payment.save!
		c = current_user
		c.plan = Plan.find(params[:payment][:plan_id]).plan_type
		c.save!
		flash[:success] = "Successfully subscribed."
		redirect_to plans_path
	end


	def update_plan
		# return render json: params.inspect
		Stripe.api_key = GlobalConstants::STRIPE_KEY
		uniqueId = Plan.find(params[:id]).plan_type
		payment = Payment.find_by_user_id(current_user)
		if payment.token.present?
			customer = Stripe::Customer.retrieve(payment.customer_id)
			subscription = customer.subscriptions.retrieve(payment.subscription_id)
			subscription.plan = uniqueId
			subscription.save

			c = current_user
			c.plan = uniqueId
			c.save!
			# customer = Stripe::Customer.retrieve(payment.customer_id)

			# #-------------- update stript subscription  ------------------
			# if payment.subscription_id.blank?
			# 	#------------- create subscription first 
			# 	response = customer.subscriptions.create(:plan => uniqueId)
			# else
			# 	# customer = Stripe::Customer.retrieve(payment.customer_id)
			# 	subscription = customer.subscriptions.retrieve(payment.subscription_id)
			# 	subscription.plan = uniqueId
			# 	response = subscription.save
			# end
			# #------------------------------------------------------------------------
			
			# payment.subscription_id = response["id"]
			# payment.plan_id = params[:plan_id]
			
			# payment.save!
			flash[:success] = "Successfully Updated Plan Subscription."
			redirect_to plans_path
		else
			flash[:notice] = "Please Enter Credit Card Information."
			redirect_to new_payment_path
		end
	end

	def plans
	end

	def feeUpdate
		Stripe.api_key = GlobalConstants::STRIPE_KEY
		@payment = Payment.find(params[:id])

		#------------------------- here to create a new plan with same id as price and should be unique
		plan = Plan.where(id: params[:payment][:quarterly_fee])
		if !plan.present?
			newPlan = Stripe::Plan.create(
			  :amount => params[:payment][:quarterly_fee].to_i,
			  :interval => 'month',
			  :name => params[:payment][:quarterly_fee],
			  :interval_count=> 3,
			  :currency => 'usd',
			  :id => params[:payment][:quarterly_fee]
			)
		
			#----------------------- here to save a new plan in local DB ------------------------
			plan = Plan.new
			plan.unique_id = params[:payment][:quarterly_fee]
			plan.plan_name = params[:payment][:quarterly_fee]
			plan.quarterly_fee  = params[:payment][:quarterly_fee]

			plan.save!
		end

		customer = Stripe::Customer.retrieve(@payment.customer_id)
		subscription = customer.subscriptions.retrieve(@payment.subscription_id)
		subscription.plan = params[:payment][:quarterly_fee]
		response = subscription.save


		@payment.subscription_id = response["id"]
		@payment.quarterly_fee = params[:payment][:quarterly_fee]
		@payment.filling_fee = params[:payment][:filling_fee]
		@payment.save!
		flash[:success] = "Successfully Updated."
		redirect_to plans_path
	end

	def update_filing_per_user
		@payment = Payment.find(params[:id])
		@payment.total_filings = params[:payment][:total_filings]
		@payment.save!
		redirect_to plans_path
	end

	def free_plan
		payment  = current_user.build_payment
		plan  = Plan.find_by_unique_id("Free")
		# payment.number_of_filings = plan.fillings_per_quarter.to_i
		payment.plan_id = plan.id.to_i
		payment.save!
		flash[:success] = "Subscribed Successfully"
		redirect_to '/ourPlans'
	end

end