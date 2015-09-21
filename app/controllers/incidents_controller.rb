class IncidentsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@components = current_user.components
    @incidents = current_user.incidents
    @states = current_user.try(:states)
    @statuses = current_user.statuses
    respond_to do |format|
      format.html
    end
  end

  def new
    @incident = Incident.new(params[:incident])
    @components = Component.where("user_id=?",current_user.id)
    @states = current_user.try(:states)
    @statuses = current_user.try(:statuses)
    @statfirst = current_user.components.first
  end

  

  def create
     # return render json: params.inspect
    if current_user.components.find_by_id(params[:incident][:component_id]).incidents.find_by_name(params[:incident][:name])
        redirect_to new_incident_path, :alert => "Incident already belongs to selected component!"
    else
      component = Component.find(params[:incident][:component_id])
      component.status_id = params[:incident][:statId]

    	@incident = component.incidents.build(params[:incident])
      @incident.user_id = current_user.id
    	if @incident.save
        component.save!
        limitexceeded = false
        somesent = false
      
        if params[:tweet]
          twitter_client = get_twitter_client
          msg = current_user.try(:tweetincidentformat)
          msg = msg.gsub("$$incident_name$$", @incident.try(:name))
          msg = msg.gsub("$$incident_state$$", State.find_by_id(@incident.try(:status).to_i).try(:name))
          msg = msg.gsub("$$component_name$$", component.name )
          msg = msg.gsub("$$component_status$$",Status.find_by_id(component.try(:status_id)).try(:name))
          if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
            twitter_client.update(msg.slice(0,139))
            u = current_user
            u.sent_notifications = u.sent_notifications+1
            u.save!
            if somesent=false
              somesent=true
            end
          else
            limitexceeded = true
          end
        end

        if params[:email]
          @user = current_user
          @sub = Subscriber.where('user_id =?',@user.id)
          @sub.each do |subscriber|
            if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
              NotificationMailer.incidentNotification(subscriber,component.try(:name),@incident.try(:name),State.find_by_id(@incident.try(:status).to_i).try(:name),@user.username,Status.find(component.status_id).try(:name)).deliver
              u = current_user
              u.sent_notifications = u.sent_notifications+1
              u.save!
              if somesent=false
                somesent=true
              end
            else
              limitexceeded = true
              break
            end
          end
        end

        if params[:sms]
          client = get_twilio_client
          twitter_client = get_twitter_client

          msg = current_user.try(:tweetincidentformat)
          msg = msg.gsub("$$incident_name$$", @incident.try(:name))
          msg = msg.gsub("$$incident_state$$", State.find_by_id(@incident.try(:status).to_i).try(:name))
          msg = msg.gsub("$$component_name$$", component.try(:name) )
          msg = msg.gsub("$$component_status$$",Status.find_by_id(component.try(:status_id)).try(:name))
          sub = Client.where('user_id =?',current_user.id)
          
          sub.each do |subscriber|
            if current_user.sent_notifications <= Plan.find_by_plan_type(current_user.plan).available_notifications
              client.messages.create(
                from: '+19165426968',
                to: subscriber.phone,
                body: msg.slice(0,159)
              )
              u = current_user
              u.sent_notifications = u.sent_notifications+1
              u.save!
              if somesent=false
                somesent=true
              end
            else
              limitexceeded = true
              break
            end
          end
        end

        if params[:email] || params[:tweet] || params[:sms]
          if limitexceeded == false
            flash[:success] = "Incident created And Notifications are sent!"
          else
            if somesent == true
              flash[:alert] = "Incident created But Notifications are not sent to all subscribers (MAX LIMIT REACHED)."
            else
              flash[:alert] = "Incident created But Notifications are not sent. (MAX LIMIT REACHED)."
            end
          end
        else
          flash[:success] = "Incident created!"
        end
    		redirect_to incidents_path
    	else
        flash[:alert] = "Incident should have a name!"
    		redirect_to new_incident_path
    	end
    end
  end

  def show
    @incident = Incident.find(params[:id])
    @statuses = current_user.statuses
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @states = current_user.try(:states)
    @incident = Incident.find(params[:id])
    @statuses = current_user.statuses
    @components = Component.all
    inci = current_user.incidents.find(params[:id])
    @statfirst = current_user.components.find_by_id(inci.component_id)
  end

  def update
    # return render json: params.inspect
    @incident = Incident.find(params[:id])
    respond_to do |format|
      if @incident.update_attributes(params[:incident])
        
        if params[:incident][:compId].present? 
          mycomp = Component.find_by_id(params[:incident][:compId])
          mycomp.status_id = params[:incident][:statId]
          mycomp.save!
        end
        format.html { redirect_to @incident, success: 'Incident was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_incident
    @incident = Incident.find(params[:id])
    @incident.description = params[:description]
    @incident.name = params[:name]
    @incident.status_id = params[:statusId]
    @incident.save!
    return render :json=> true
  end

  def destroy
    @incident = Incident.find(params[:id])
    @incident.destroy

    respond_to do |format|
      format.html { redirect_to incidents_url, success: 'Incident is removed.' }
      format.json { head :no_content }
    end
  end

  def get_component_status
    @statuses = current_user.statuses
    @stat = current_user.components.find_by_id(params['select_id'])
    @statfirst = current_user.components.first
    @id = params['select_id']
    return render partial: "incidents/get_component_status"
  end 

  protected

  def get_twitter_client
    twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key = GlobalConstants::TWITTER_COMSUMER_KEY
        config.consumer_secret = GlobalConstants::TWITTER_COMSUMER_SECRET
        config.oauth_token = GlobalConstants::TWITTER_OATH_TOKEN
        config.oauth_token_secret = GlobalConstants::TWITTER_OATH_TOKEN_SECRET
    end
    twitter_client
  end
  def get_twilio_client
    require 'rubygems' # not necessary with ruby 1.9 but included for completeness
    require 'twilio-ruby'

    # put your own credentials here
    account_sid = GlobalConstants::TWILIO_ACCOUNT_SID
    auth_token = GlobalConstants::TWILIO_AUTH_TOKEN

    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new account_sid, auth_token
    return client
  end
end
