class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user && current_user.user_type == "admin"
    	@usersA = User.where("user_type=?",'null')
    	@usersS = User.where("user_type=?",'1')
      @usercustomurl = current_user
      respond_to do |format|
        format.html
    	end
    else
      flash[:alert] = "Access denied !"
      redirect_to root_url
    end
  end

  def edit
    if current_user && current_user.user_type == "admin"
  	  @user = User.find(params[:id])
    else
      flash[:alert] = "Access denied !"
      redirect_to root_url
    end
  end

  def update
    @user = User.find(params[:id])
    # @component.description = params[:description]
    # @component.name = params[:name]
    # @component.save!
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, success: 'User was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    components1 = Component.where("user_id = ?", params[:id])
    maintenances1 = Maintenance.where(component_id: components1)
    maintenances1.try(:destroy_all)
    components1.try(:destroy_all)

    customizepage1 = Customizepage.find_by_user_id(params[:id])
    customizepage1.try(:destroy)

    datasources1 = Datasource.where("user_id = ?", params[:id])
    metrics1 = Metric.where(datasource_id: datasources1)
    metrics1.try(:destroy_all)
    datasources1.try(:destroy_all)

    incidents1 = Incident.where("user_id = ?", params[:id])
    incidents1.try(:destroy_all)

    states1 = State.where("user_id = ?", params[:id])
    states1.try(:destroy_all)

    statuses1 = Status.where("user_id = ?", params[:id])
    statuses1.try(:destroy_all)
    
    subscribers1 = Subscriber.where("user_id = ?", params[:id])
    subscribers1.try(:destroy_all)
    
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def show
    begin
      if current_user && current_user.user_type == "admin"
        @user = User.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @project }
        end
      else
        flash[:alert] = "Access denied !"
        redirect_to root_url
      end
    rescue Exception => e
      respond_to do |format|
            format.html { render :file => "#{Rails.root}/public/404", :status => :not_found }
      end
    end
  end

  def incident
  	if current_user && current_user.user_type == "admin"
      @incidents = Incident.where("user_id=?",params[:id])
    	@user = User.find(params[:id])

      respond_to do |format|
        format.html
      end
    else
      flash[:alert] = "Access denied !"
      redirect_to root_url
    end
  end

  def typeChange
    @user = User.find(params[:id])

    if @user.user_type == "null"
      @user.user_type = "1"
      @user.save!
      redirect_to users_path, success: 'User status changed to Suspended.'
    elsif @user.user_type == "1"
      @user.user_type = "null"
      @user.save!
      redirect_to users_path, success: 'User status changed to Active.'
    end
  end

  def settings
    @usercustomurl = current_user
    @usertimeZ = current_user
    @usernotif = current_user
    @userHistory = current_user
    @statuses  = current_user.statuses
    @status = Status.new(params[:status])
    @states = current_user.states
    @state = State.new(params[:state])
    
  end

  def saveTime

    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'Time Zone Changed successfully!'
        format.html { redirect_to settings_user_path(tab: "home") }
        format.json { head :no_content }
      end
    end
  end

  def saveHistory

    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'History Limit Changed successfully!'
        format.html { redirect_to settings_user_path(tab: "history")}
        format.json { head :no_content }
      end
    end
  end

  def saveNotificationFormats
    # return render json: params.inspect
    @usernotif = User.find(params[:id]) 
    if @usernotif.update_attributes(params[:user])
      flash[:success] = "Notifications Formats Saved !"
      redirect_to  settings_user_path(tab: "notif_format")
      # redirect_to  settings_user_path
    else
      flash[:alert] = "Failed to save the Formats !"
      redirect_to settings_user_path(tab: "notif_format")
      # redirect_to  settings_user_path
    end
  end

  def status
    status = current_user.statuses.find(params[:status][:id])
    status.name = params[:status][:name]
    if status.save!
        flash[:success] = 'Status successfully updated!'
        redirect_to settings_user_path(tab: "status")
    else
       flash[:alert] = 'Status cannot be updated!'
        redirect_to settings_user_path(tab: "status") 
    end
  end

  def state
    state = current_user.states.find(params[:state][:id])
    state.name = params[:state][:name]
    if state.save!
        flash[:success] = 'State successfully updated!'
        redirect_to settings_user_path(tab: "state")
    else
       flash[:alert] = 'State cannot be updated!'
        redirect_to settings_user_path(tab: "state") 
    end
  end

  def addcustomurl
    # return render json: params.inspect
    @usercustomurl = current_user
    if User.find_by_customurl(params['user']['customurl']) && params['user']['customurl'] != ""
      flash[:alert] = 'This URL is already taken!'
      redirect_to settings_user_path(tab: "url1")
    else
      @usercustomurl.customurl = params['user']['customurl']
      @usercustomurl.save!
      flash[:success] = 'Updated Custom URL successfully!'
      redirect_to settings_user_path(tab: "url1")
    end
  end

  def subscribers
    @subscribers = Subscriber.where("user_id =?", params[:id])
    @clients = Client.where("user_id =?", params[:id])
    
  end

  def delete_subscriber
    # return render json: params.inspect
    @subscriber = Subscriber.find(params[:id])
    @subscriber.destroy

    flash[:success] = 'Subscriber email successfully deleted!'
    redirect_to subscribers_user_path(current_user, tab: "email")
  end

  def delete_client
    # return render json: params.inspect
    @client = Client.find(params[:id])
    @client.destroy

    flash[:success] = 'Subscriber phone number successfully deleted!'
    redirect_to subscribers_user_path(current_user, tab: "sms")
  end
end
