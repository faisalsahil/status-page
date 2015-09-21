class CustomizepagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:theme2, :subscribe, :history, :smsSubscribe]
  
  def index
    if current_user.present?
  	   @customizepage = current_user.try(:customizepage)
      @usercustomurl = current_user
    end
  end

  def create
  	# @customizepage1 = Customizepage.new(params[:customizepage])
   #  @customizepage1.user_id = current_user.id
  	# if @customizepage1.save
   #    redirect_to customizepages_path, :notice => "All the changes saved successfully!"
   #  else
   #    redirect_to customizepages_path, :alert => "Couldn't save changes"
   #  end
 end

 def update
    @customizepage = current_user.customizepage
    @customizepage.theme = "theme2"
    begin
      if @customizepage.update_attributes(params[:customizepage])
        flash[:success] = "All the changes saved successfully!"
        redirect_to customizepages_path
      else
        flash[:alert] = "Couldn't save changes"
        redirect_to customizepages_path   
      end
    rescue Exception => e
      flash[:alert] = "Couldn't save changes. Image dimensions are not valid!"
        redirect_to customizepages_path
    end
end

def css_html_update
  @customizepage = current_user.customizepage

    if @customizepage.update_attributes(params[:customizepage])
      flash[:success] = "All the changes saved successfully!"
      redirect_to customizepages_customhtml_path
    else
      flash[:alert] = "Couldn't save changes"
      redirect_to customizepages_customhtml_path
    end
end

def theme1
  @customizepage = current_user.customizepage
  @incidents = current_user.incidents.where("status =?",'Resolved').find(:all, :order => "created_at DESC")
  @unresolved_incidents = current_user.incidents.where("status !=?",'Resolved').find(:all, :order => "created_at DESC")
  @components = current_user.components
  render layout: false
end

def history
  # puts '---'*80
  if current_user
    @user = current_user

    @components = @user.try(:components).order('created_at desc').limit(10)
    @statuses = @user.statuses

    respond_to do |format|
        format.rss {render action: 'history.rss', :layout => false}
    end

  elsif request.referrer.present?
    url =  (URI(request.referrer).path).to_s.gsub(/[\s\/]/, '')
    if (url).present?    
      if User.find_by_customurl(url)
        @user = User.find_by_customurl(url)
      end
    end

    @components = @user.try(:components).order('created_at desc').limit(10)
    @statuses = @user.statuses

    respond_to do |format|
        format.rss {render action: 'history.rss', :layout => false}
    end
  else
    respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :status => :not_found }
    end
  end
end

def theme2
  require 'date'
  
  if params[:userurl].present?
    
    if User.find_by_customurl(params[:userurl])
       @user = User.find_by_customurl(params[:userurl])
    end
    if params[:subscriber].present?
      @subscriber = @user.subscriber.build(params[:subscriber])
    end
    if params[:clients].present?
      @sms = @user.sms.build(params[:clients])
    end
  else
    
    @user = current_user
    if params[:subscriber].present?
      @subscriber = @user.subscriber.build(params[:subscriber])
    end
    if params[:clients].present?
      @sms = @user.sms.build(params[:clients])
    end
  end

  if @user.present?
    @customizepage = @user.customizepage
    # if @user.history > 0
    @incidents = @user.incidents.where("status =? AND created_at >=?", @user.try(:states).try(:last).try(:id), Date.today - @user.history).find(:all, :order => "created_at DESC")
    
    # end
    # st = State.find_by_id(incident.try(:status).to_i) 
    #   st.name
    @unresolved_incidents = @user.incidents.where("status !=?", @user.try(:states).try(:last).try(:id) ).find(:all, :order => "created_at DESC")
    @components = @user.components
    @firstcomponent = @user.components.first
    @subscriber = Subscriber.new
    @sms = Client.new
    
    @maintenance = Maintenance.where(component_id: @components)

    @validMaintenance = @maintenance.where("end_at >=?",DateTime.now)

    @pingcredentials  = @user.datasources.where(source_name: "pingdom").first
    @siteuptcredentials = @user.datasources.where(source_name: "siteuptime").first
    ######### Synchronizing pingdom checks with our database
    @newmetric = ""
      metricscount = 0
      oldmetrics = []
      metricsfromsite = []
    if @pingcredentials
      response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => @pingcredentials.ds_email, :password => @pingcredentials.ds_pass}, :headers => { "App-Key" => @pingcredentials.ds_appkey })
      response["checks"].each do |check|    
         metricsfromsite << check["hostname"]
        if @user.datasources.find_by_source_name("pingdom").metrics.find_by_hostname(check["hostname"])
        else
          @newmetric = @user.datasources.find_by_source_name("pingdom").metrics.build
            @newmetric.hostname = check["hostname"]
            @newmetric.status = check["status"]
            @newmetric.name = check["name"]
            @newmetric.save!
        end
      end
      oldmetrics = @user.datasources.find_by_source_name("pingdom").metrics.all
      number_of_metrics = @user.datasources.find_by_source_name("pingdom").metrics.count

      while metricscount < number_of_metrics do 
        if metricsfromsite.index oldmetrics[metricscount].hostname
        else
          oldmetrics[metricscount].delete
        end
        metricscount = metricscount + 1 
      end
    end
    ######### Synchronizing siteuptime checks with our database
    @newmetricsut = ""
    metricscountsut = 0
    oldmetricssut = []
    metricsfromsitesut = []

    if @siteuptcredentials
        responsesut = HTTParty.get("https://siteuptime.com/api/rest/?method=siteuptime.monitors&AuthKey="+@siteuptcredentials.ds_appkey)
        if responsesut["rsp"]["stat"] == "fail"
            
          else
          responsesut["rsp"]["monitors"]["monitor"].each do |check|   
            metricsfromsitesut << check["host"]
              if @user.datasources.find_by_source_name("siteuptime").metrics.find_by_hostname(check["host"])
              else
                @newmetricsut = @user.datasources.find_by_source_name("siteuptime").metrics.build
                  @newmetricsut.hostname = check["host"].to_s
              if check["active"] == "yes"
                    @newmetricsut.status = "up"
              elsif check["active"] == "no"
                @newmetricsut.status = "down"
              end
                  @newmetricsut.name = check["name"].to_s
                  @newmetricsut.save!
              end
          end
        end
      oldmetricssut = @user.datasources.find_by_source_name("siteuptime").metrics.all
      number_of_metricssut = @user.datasources.find_by_source_name("siteuptime").metrics.count

      while metricscountsut < number_of_metricssut do 
        if metricsfromsitesut.index oldmetricssut[metricscountsut].hostname
        else
          oldmetricssut[metricscountsut].delete
        end
        metricscountsut = metricscountsut + 1 
      end
    end
    render layout: false
  else
    respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :status => :not_found }
    end
  end
    
end

def customhtml
  @customizepage = current_user.customizepage

  render layout: false
end

def show
  # @customshow = Customizepage.find_by_user_id(current_user.id)
  @customshow = current_user.customizepage

  if @customshow.theme == "theme1"
    redirect_to customizepages_theme1_path
  elsif @customshow.theme == "theme2"
    redirect_to customizepages_theme2_path
  end
end

  def subscribe
    # return render json: params.inspect

    @user = User.find params[:id]
    s = Subscriber.where("user_id =? AND email =?", params[:id],params['subscriber']['email'])
    if s.present?
      flash[:alert] = "Woah ! You are already our subscriber!"
      redirect_to :back
    else
      @subscriber = @user.subscribers.build
      @subscriber.email = params['subscriber']['email']
     
      if @subscriber.save
        flash[:success] = "Hurrah ! Successfully Subscribed!"
        redirect_to :back
      else
        flash[:alert] = "Woah ! You are already our subscriber!"
        redirect_to :back
      end
    end
  end

  def smsSubscribe
    # return render json: params.inspect

    @user = User.find params[:id]
    s = Client.where("user_id =? AND phone =?", params[:id],params['client']['phone'])
    if s.present?
      flash[:alert] = "Woah ! You are already our subscriber!"
      redirect_to :back
    else
      @subscriber = @user.clients.build
      @subscriber.phone = params['client']['phone']
     
      if @subscriber.save
        flash[:success] = "Hurrah ! Successfully Subscribed!"
        redirect_to :back
      else
        flash[:alert] = "Woah ! You are already our subscriber!"
        redirect_to :back
      end
    end
  end
    
end
