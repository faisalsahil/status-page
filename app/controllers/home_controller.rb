
class HomeController < ApplicationController
  before_filter :authenticate_user!, except:[:index]

  def index
    if current_user && current_user.try(:customizepage).present?
    elsif current_user
      @customizepagecreate = current_user.build_customizepage
      @customizepagecreate.theme = "theme2"
      @customizepagecreate.background_color = "#ffffff"
      @customizepagecreate.font_color = "#000000"
      @customizepagecreate.link_color = "#0000ff"
      @customizepagecreate.yellows = "#ffff00"
      @customizepagecreate.reds = "#ff0000"
      @customizepagecreate.greens = "#008000"
      @customizepagecreate.logoname = current_user.username
      @customizepagecreate.abouttexttitle = "Description"
      @customizepagecreate.systemcomponentstitle = "System Components"
      @customizepagecreate.abouttext = "This is dummy about text."
      @customizepagecreate.save!
    end
    if current_user && current_user.statuses.blank?
      statuses = ["Fully Operational","Scheduled Maintenance","Minor Interruption","Major Interruption"]
      statuses.each do |status|
        @status = current_user.statuses.build
        @status.name = status
        @status.default_value = status
        @status.save!
    end
    end
    if current_user && current_user.states.blank?
      states = ["Investigating","Identified","Monitoring","Resolved"]
      states.each do |state|
        @state = current_user.states.build
        @state.name = state
        @state.default_value = state
        @state.save!
      end
    end
    if current_user && current_user.random_key.blank?
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      string = (0...50).map { o[rand(o.length)] }.join

      @user = current_user
      @user.random_key = string
      @user.save!
    end
    if current_user && current_user.tweetformat.blank?
      @notif_user = current_user
      @notif_user.tweetformat = "Status of @"+current_user.username+" : Component \"$$component_name$$\" has status \"$$component_status$$\""
      @notif_user.save!
    end
    if current_user && current_user.tweetincidentformat.blank?
      @notif_user = current_user
      @notif_user.tweetincidentformat = "Status of @"+current_user.username+" : Incident \"$$incident_name$$\" has state \"$$incident_state$$\" Belongs to Component: \"$$component_name$$\""
      @notif_user.save!
    end
    if current_user && current_user.emailsubjectformat.blank?
        @notif_user = current_user
        @notif_user.emailsubjectformat = current_user.username+" website Status Notification"
        @notif_user.save!
    end
    if current_user && current_user.emailbodyformat.blank?
        @notif_user = current_user
        @notif_user.emailbodyformat = "Status of "+current_user.username+" website. \n Following component status is changed. Details are as under... \n Component Name: \"$$component_name$$\" \n Status: \"$$component_status$$\" \n \n Thank you for subscribing. "
        @notif_user.save!
    end
    if current_user && current_user.emailsubjectincidentformat.blank?
      @notif_user = current_user
      @notif_user.emailsubjectincidentformat = current_user.username+" website Status Notification"
      @notif_user.save!
    end
    if current_user && current_user.emailbodyincidentformat.blank?
      @notif_user = current_user
      @notif_user.emailbodyincidentformat = "Status of "+current_user.username+" website. \n Following incident status is changed. Details are as under... \n Incident Name: \"$$incident_name$$\" \n Belongs to Component: \"$$component_name$$\" \n Incident State: \"$$incident_state$$\" \n \n Thank you for subscribing."
      @notif_user.save!
    end
  end

  def dashboard
    # @mywebhook = HTTParty.get("http://localhost:3000/notifications/multiply", :params => {:x => 10, :y => 10})
    # @components = Component.where(user_id:,current_user.id)
    @components = current_user.components
  	@incidents = current_user.incidents.where("status !=?",'Resolved')
    @statuses = current_user.statuses
    @states = current_user.states
    respond_to do |format|
      format.html
    end
  end
  
  def create
  	# @incident = Incident.new(params[:incident])
   #  @incident.user_id = current_user.id
  	# if @incident.save
  	# 	redirect_to home_dashboard_path, :success => "Incident created!"
  	# else
   #    redirect_to home_dashboard_path, :alert => "Incident should have a name!"
  	# end
    if current_user.components.find_by_name(params['component']['name'])
        redirect_to components_path, :alert => "Component is already present!"
    else
      @component = Component.new(params[:component])
      @component.user_id = current_user.id
      ######## Creating a random string
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      string = (0...50).map { o[rand(o.length)] }.join

      if @component.save
        @component.random_key = @component.id.to_s+"_"+string
        @component.save!
        flash[:success] = "Your First Component is added! Add more or manage in Components section."
        redirect_to home_dashboard_path
      else
        render :new
      end
    end
  end

  def status_change
    @component = Component.find(params[:id])
    @component.status_id = params[:statusid]
    @component.save!
    return render :json=> true
  end
end
