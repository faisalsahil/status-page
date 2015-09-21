class ResourcesController < ApplicationController
  before_filter :authenticate_user!, except:[:embed]
  def index
  	if current_user && current_user.datasources.find_by_source_name("pingdom")
  		@dbPresent = current_user.datasources.find_by_source_name("pingdom");
  	# else
  	# 	@dbPresent = current_user.datasources.build
  		
  	end

  end

  
  def embed
    
    @user = User.find_by_random_key(params[:id])
    # @datasource = Datasource.find_by_user_id(@user.id)
    

#=================Pingdom and siteuptime checking data=============================================

    # if @user.present?
    #   @pingcredentials  = @user.datasources.where(source_name: "pingdom").first
    #   @siteuptcredentials = @user.datasources.where(source_name: "siteuptime").first
    #   ######### Synchronizing pingdom checks with our database
    #   @newmetric = ""
    #     metricscount = 0
    #     oldmetrics = []
    #     metricsfromsite = []
    #   if @pingcredentials
    #     response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => @pingcredentials.ds_email, :password => @pingcredentials.ds_pass}, :headers => { "App-Key" => @pingcredentials.ds_appkey })
    #     response["checks"].each do |check|    
    #        metricsfromsite << check["hostname"]
    #       if @user.datasources.find_by_source_name("pingdom").metrics.find_by_hostname(check["hostname"])
    #       else
    #         @newmetric = @user.datasources.find_by_source_name("pingdom").metrics.build
    #           @newmetric.hostname = check["hostname"]
    #           @newmetric.status = check["status"]
    #           @newmetric.name = check["name"]
    #           @newmetric.save!
    #       end
    #     end
    #     oldmetrics = @user.datasources.find_by_source_name("pingdom").metrics.all
    #     number_of_metrics = @user.datasources.find_by_source_name("pingdom").metrics.count

    #     while metricscount < number_of_metrics do 
    #       if metricsfromsite.index oldmetrics[metricscount].hostname
    #       else
    #         oldmetrics[metricscount].delete
    #       end
    #       metricscount = metricscount + 1 
    #     end
    #   end
    #   ######### Synchronizing siteuptime checks with our database
    #   @newmetricsut = ""
    #   metricscountsut = 0
    #   oldmetricssut = []
    #   metricsfromsitesut = []


    #   if @siteuptcredentials
    #       responsesut = HTTParty.get("https://siteuptime.com/api/rest/?method=siteuptime.monitors&AuthKey="+@siteuptcredentials.ds_appkey)
          
    #       if responsesut["rsp"]["stat"] == "fail"
            
    #       else
    #         responsesut["rsp"]["monitors"]["monitor"].each do |check|   
    #           metricsfromsitesut << check["host"]
    #             if @user.datasources.find_by_source_name("siteuptime").metrics.find_by_hostname(check["host"])
    #             else
    #               @newmetricsut = @user.datasources.find_by_source_name("siteuptime").metrics.build
    #                 @newmetricsut.hostname = check["host"].to_s
    #             if check["active"] == "yes"
    #                   @newmetricsut.status = "up"
    #             elsif check["active"] == "no"
    #               @newmetricsut.status = "down"
    #             end
    #                 @newmetricsut.name = check["name"].to_s
    #                 @newmetricsut.save!
    #             end
    #         end
    #       end

    #     oldmetricssut = @user.datasources.find_by_source_name("siteuptime").metrics.all
    #     number_of_metricssut = @user.datasources.find_by_source_name("siteuptime").metrics.count

    #     while metricscountsut < number_of_metricssut do 
    #       if metricsfromsitesut.index oldmetricssut[metricscountsut].hostname
    #       else
    #         oldmetricssut[metricscountsut].delete
    #       end
    #       metricscountsut = metricscountsut + 1 
    #     end
    #   end



    #=============================pingdom and siteuptime checking ends here============================


    #   @datasource_ids = @user.datasources.pluck(:id)
    # # @metrices = Metric.where(:displayit => 1).find_by_datasource_id(@datasource.id)
    #   if @datasource_ids.present? 
    #     @metrices = Metric.where(datasource_id: @datasource_ids, displayit: true)
    #   end
    # end

    if @user
        @components = Component.where(user_id: @user)
        @component_ids = @user.components.pluck(:id)

        if @component_ids.present?
          @incidents = Incident.where(component_id: @component_ids)
          @status = @user.statuses
          @state = @user.states
        end

        respond_to do |format|
          format.html {render :layout => "another"}
          format.json {render :json => { :user => @user.to_json(:only => [:username]), :component => @components.to_json(:only => [:id, :name, :status_id]), :status => @status.to_json(:only => [:id, :name]), :incident => @incidents.to_json(:only => [:name, :status, :component_id, :message]), :state => @state.to_json(:only => [:id, :name])}}
          # format.js
        end
    else
        respond_to do |format|
            format.html { render :file => "#{Rails.root}/public/404", :layout => "another", :status => :not_found }
        end
    end
  end
end
