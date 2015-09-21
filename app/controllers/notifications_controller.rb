class NotificationsController < ApplicationController
  before_filter :authenticate_user!, except:[:multiply]

  def index
    @components = current_user.try(:components)
    @incidents = current_user.incidents
    @states = current_user.try(:states)
    @statuses = current_user.statuses
  end

  def sendIncidentEmail
    @incident = Incident.find(params[:id])
    @user = current_user
    @sub = Subscriber.where('user_id =?',@user.id)
    @component = Component.find_by_id(@incident.component_id)
    limitexceeded = false
    @sub.each do |subscriber|
      ## checking if limit is reached to maximum according to the plan
      if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
        NotificationMailer.incidentNotification(subscriber,@component.try(:name),@incident.try(:name),State.find_by_id(@incident.try(:status).to_i).try(:name),@user.username,Status.find(@component.try(:status_id)).try(:name)).deliver
        u = current_user
        u.sent_notifications = u.sent_notifications+1
        u.save! 
      else
        limitexceeded = true
        break
      end
    end
    if limitexceeded == true
      
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    else
      redirect_to notifications_path, :notice => "Notification of \""+@incident.try(:name)+"\" incident Successfully sent to your subscribers."
    end
  end

  def sendComponentEmail
    @component = Component.find(params[:id])
    @user = current_user
    @sub = Subscriber.where('user_id =?',@user.id)
    limitexceeded = false
    @sub.each do |subscriber|
      ## checking if limit is reached to maximum according to the plan
      if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
        NotificationMailer.notification(subscriber,@component.try(:name),Status.find(@component.try(:status_id)).try(:name),@user.username).deliver
        u = current_user
        u.sent_notifications = u.sent_notifications+1
        u.save! 
      else
        limitexceeded = true
        break
      end
    end
    if limitexceeded == true
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    else
      redirect_to notifications_path, :notice => "Notification of \""+@component.try(:name)+"\" component Successfully sent to your subscribers."
    end
  end

  def sendComponentTweet
    @component = current_user.components.find(params[:id])
    twitter_client = get_twitter_client
    # msg = "Status of @"+current_user.username+" : Component \""+@component.try(:name)+"\" has status \""+Status.find(@component.try(:status_id)).try(:name)+"\""
    
    msg = current_user.try(:tweetformat)
    msg = msg.gsub("$$component_name$$",@component.try(:name))
    msg = msg.gsub("$$component_status$$",Status.find(@component.try(:status_id)).try(:name))
    
    if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
      if twitter_client.update(msg.slice(0,139))
        redirect_to notifications_path, :notice => "Successfully Tweeted!"
      end
      u = current_user
      u.sent_notifications = u.sent_notifications+1
      u.save!
    else
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    end
  end

  def sendIncidentTweet
    @incident = current_user.incidents.find(params[:id])
    @component = current_user.components.find_by_id(@incident.component_id)
    twitter_client = get_twitter_client
    # msg = "Status of @"+current_user.username+" : Incident \""+@incident.try(:name)+"\" has state \""+State.find_by_id(@incident.try(:status).to_i).try(:name)+"\" Belongs to Component: "+"\""+@component.try(:name)+"\""
    msg = current_user.try(:tweetincidentformat)
    
    msg = msg.gsub("$$incident_name$$", @incident.try(:name))
    msg = msg.gsub("$$incident_state$$", State.find_by_id(@incident.try(:status).to_i).try(:name))
    msg = msg.gsub("$$component_name$$", @component.try(:name) )
    msg = msg.gsub("$$component_status$$",Status.find_by_id(@component.try(:status_id)).try(:name))

     if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
      if twitter_client.update(msg.slice(0,139))
        redirect_to notifications_path, :notice => "Successfully Tweeted!"
      end
      u = current_user
      u.sent_notifications = u.sent_notifications+1
      u.save!
    else
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    end
  end

  def send_incident_sms
    @client = get_twilio_client
    
    @incident = current_user.incidents.find(params[:id])
    @component = current_user.components.find_by_id(@incident.component_id)
    twitter_client = get_twitter_client
    msg = current_user.try(:tweetincidentformat)
    msg = msg.gsub("$$incident_name$$", @incident.try(:name))
    msg = msg.gsub("$$incident_state$$", State.find_by_id(@incident.try(:status).to_i).try(:name))
    msg = msg.gsub("$$component_name$$", @component.try(:name) )
    msg = msg.gsub("$$component_status$$",Status.find_by_id(@component.try(:status_id)).try(:name))
    @sub = Client.where('user_id =?',current_user.id)
    limitexceeded = false
    @sub.each do |subscriber|
      if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
        @client.messages.create(
          from: '+19165426968',
          to: subscriber.phone,
          body: msg.slice(0,159)
        )
        u = current_user
        u.sent_notifications = u.sent_notifications+1
        u.save!
      else
        limitexceeded = true
        break
      end
    end
    if limitexceeded == true
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    else
      redirect_to notifications_path, :notice => "Notification of \""+@incident.try(:name)+"\" incident Successfully sent to your subscribers via sms."
    end
  end

  def send_component_sms
    @client = get_twilio_client
    
    @component = current_user.components.find(params[:id])
    twitter_client = get_twitter_client
    msg = current_user.try(:tweetformat)
    msg = msg.gsub("$$component_name$$",@component.try(:name))
    msg = msg.gsub("$$component_status$$",Status.find(@component.try(:status_id)).try(:name))
    @sub = Client.where('user_id =?',current_user.id)
    limitexceeded = false
    @sub.each do |subscriber|
      if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
        @client.messages.create(
          from: '+19165426968',
          to: subscriber.phone,
          body: msg.slice(0,159)
        )
        u = current_user
        u.sent_notifications = u.sent_notifications+1
        u.save!
      else
        limitexceeded = true
        break
      end
    end
    if limitexceeded == true
      redirect_to notifications_path, :alert => "Sorry! Notifications limit reached to maximum."
    else
      redirect_to notifications_path, :notice => "Notification of \""+@component.try(:name)+"\" component Successfully sent to your subscribers via sms."
    end
  end

  protected

  def get_twitter_client
    twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key = GlobalConstants::TWITTER_COMSUMER_KEY
        config.consumer_secret = GlobalConstants::TWITTER_COMSUMER_SECRET
        config.oauth_token = GlobalConstants::TWITTER_OATH_TOKEN
        config.oauth_token_secret = GlobalConstants::TWITTER_OATH_TOKEN_SECRET
    end
    return twitter_client
  end

  def get_twilio_client
    require 'rubygems' # not necessary with ruby 1.9 but included for completeness
    require 'twilio-ruby'

    # put your own credentials here
    account_sid = GlobalConstants::TWILIO_ACCOUNT_SID
    auth_token = GlobalConstants::TWILIO_AUTH_TOKEN

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
    return @client
  end
end
