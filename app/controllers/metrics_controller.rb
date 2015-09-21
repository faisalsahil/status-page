class MetricsController < ApplicationController
  before_filter :authenticate_user!
  
def index
  	@datasource = current_user.datasources.find_by_source_name("pingdom") || current_user.datasources.build
  	@datasourcesut = current_user.datasources.find_by_source_name("siteuptime") || current_user.datasources.build

  	@userdatasources = current_user.datasources.all

  	# @pingcredentials = Datasource.find_by_user_id_and_source_name( current_user.id , "pingdom")
    @pingcredentials  = current_user.datasources.where(source_name: "pingdom").first

  	# @siteuptcredentials = Datasource.find_by_user_id_and_source_name( current_user.id , "siteuptime")
    @siteuptcredentials = current_user.datasources.where(source_name: "siteuptime").first

  	@updated_metric = Metric.new

    ######### Synchronizing pingdom checks with our database
  	@newmetric = ""
  	metricscount = 0
  	oldmetrics = []
  	metricsfromsite = []
  	if @pingcredentials
  		response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => @pingcredentials.ds_email, :password => @pingcredentials.ds_pass}, :headers => { "App-Key" => @pingcredentials.ds_appkey })
  		response["checks"].each do |check|		
  			metricsfromsite << check["hostname"]
  	    		if current_user.datasources.find_by_source_name("pingdom").metrics.find_by_hostname(check["hostname"])
  	    		else
  	    			@newmetric = current_user.datasources.find_by_source_name("pingdom").metrics.build
  			       	@newmetric.hostname = check["hostname"]
  			       	@newmetric.status = check["status"]
  			      	@newmetric.name = check["name"]
  			      	@newmetric.save!
  	    		end
		  end

		oldmetrics = current_user.datasources.find_by_source_name("pingdom").metrics.all
		number_of_metrics = current_user.datasources.find_by_source_name("pingdom").metrics.count

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
  	    		if current_user.datasources.find_by_source_name("siteuptime").metrics.find_by_hostname(check["host"])
  	    		else
  	    			@newmetricsut = current_user.datasources.find_by_source_name("siteuptime").metrics.build
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

		oldmetricssut = current_user.datasources.find_by_source_name("siteuptime").metrics.all
		number_of_metricssut = current_user.datasources.find_by_source_name("siteuptime").metrics.count

		while metricscountsut < number_of_metricssut do 
			if metricsfromsitesut.index oldmetricssut[metricscountsut].hostname
			else
				oldmetricssut[metricscountsut].delete
			end
			metricscountsut = metricscountsut + 1 
		end
	
		
  end
end

  def pingdom_auth
  	@datasource = current_user.datasources.build(params[:datasource])
  	# @datasource.user_id = current_user.id
    @datasource.source_name = "pingdom"
    usremail = @datasource.ds_email
    usrpass = @datasource.ds_pass
    usrappkey = @datasource.ds_appkey
    response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => usremail, :password => usrpass}, :headers => { "App-Key" => usrappkey }) 
    if response["error"]
    	flash[:alert] = response['error']['errormessage'].to_s
    	redirect_to metrics_path
    elsif @datasource.save
    	flash[:success] = "Datasource successfully added!"
    	redirect_to metrics_path
    else
    	flash[:alert] = "Couldn't Save this datasource!"
    	redirect_to metrics_path
    end
  end

  def siteuptime_auth
  	@datasourcesut = current_user.datasources.build(params[:datasource])
  	# @datasource.user_id = current_user.id
    @datasourcesut.source_name = "siteuptime"
    usremail1 = @datasourcesut.ds_email
    usrpass1 = @datasourcesut.ds_pass
    responsesitesut = HTTParty.get("https://siteuptime.com/api/rest/?method=siteuptime.auth&Email="+usremail1+"&Password="+usrpass1) 
    @responsesite = responsesitesut
    if responsesitesut["rsp"]["stat"] == "fail"
    	flash[:alert] = responsesitesut['rsp']['err']['msg'].to_s
    	redirect_to metrics_path
    else
    	@datasourcesut.ds_appkey = responsesitesut['rsp']['session']['key'].to_s
    	if @datasourcesut.save
	    	flash[:success] = "Datasource successfully added!"
	    	redirect_to metrics_path
   		else
	    	flash[:alert] = "Couldn't Save this datasource!"
	    	redirect_to metrics_path
    	end
    end
  end

  def pingdom_auth_update
  	@datasource = current_user.datasources.find_by_source_name("pingdom")
  	@updated_datasource = Datasource.new(params[:datasource])
  	usremail1 = @updated_datasource.ds_email
    usrpass1 = @updated_datasource.ds_pass
    usrappkey1 =@updated_datasource.ds_appkey
    response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => usremail1, :password => usrpass1}, :headers => { "App-Key" => usrappkey1 }) 
    if response["error"]
    	flash[:alert] = response['error']['errormessage'].to_s
    	 redirect_to metrics_path
    elsif @datasource.update_attributes(params[:datasource])
  		flash[:success] = "Updated Pingdom Credentials"
  		 redirect_to metrics_path
    else
    	flash[:alert] = "Couldn't Update the Credentials!"
    	 redirect_to metrics_path 
    end
  end

  def siteuptime_auth_update
  	@datasourcesut = current_user.datasources.find_by_source_name("siteuptime")
  	@updated_datasource = Datasource.new(params[:datasource])
  	usremail1 = @updated_datasource.ds_email
    usrpass1 = @updated_datasource.ds_pass
    responsesut = HTTParty.get("https://siteuptime.com/api/rest/?method=siteuptime.auth&Email="+usremail1+"&Password="+usrpass1)
    #response = HTTParty.get("https://siteuptime.com/api/rest/?method=siteuptime.monitors&AuthKey="+@siteuptcredentials.ds_appkey) 
    if responsesut["rsp"]["stat"] == "fail"
    	flash[:alert] = responsesut['rsp']['err']['msg'].to_s
    	redirect_to metrics_path
    else
    	@datasourcesut.ds_appkey = responsesut['rsp']['session']['key'].to_s
    	if @datasourcesut.update_attributes(params[:datasource])
	  		flash[:success] = "Updated siteuptime Credentials"
	  		 redirect_to metrics_path
	    else
	    	flash[:alert] = "Couldn't Update the Credentials!"
	    	 redirect_to metrics_path
	    end
    end
  end

  def destroy_pingdom_link
    @datasource = current_user.datasources.find_by_source_name("pingdom")
    @datasource.delete
    flash[:success] = "Unlinked your Pingdom account"
    redirect_to metrics_path
  end

  def destroy_siteuptime_link
    @datasource = current_user.datasources.find_by_source_name("siteuptime")
    @datasource.delete
    flash[:success] = "Unlinked your Siteuptime account"
    redirect_to metrics_path
  end

  def add_metric
  	#### DUMMY Metric
  	# return render json: params.inspect
  	@metrictoupdate = current_user.datasources.find_by_id(params[:metric][:datasourcearr]).metrics.find_by_id(params[:metric][:name])
  	@metrictoupdate.userdef_name = params[:metric][:userdef_name]
  	@metrictoupdate.displayit = true;
  	if @metrictoupdate.save
  		flash[:success] = "Loaded Metric Successfully"
  		redirect_to metrics_path
  	else
  		flash[:alert] = "Couldn't Load Metric!"
    	 redirect_to metrics_path 
  	end
  end

  def unload_metric
  	# return render json: params.inspect
  	@ulmetric = Metric.find_by_id(params[:id])
  	@ulmetric.displayit = false
  	if @ulmetric.save
  		flash[:success] = "Unloaded Metric Successfully"
  		redirect_to metrics_path
  	else
  		flash[:alert] = "Couldn't Unload Metric!"
    	 redirect_to metrics_path 
  	end
  end

  def get_options
  	@id = params['select_id']
  	return render partial: "metrics/get_options"
  end	
end
