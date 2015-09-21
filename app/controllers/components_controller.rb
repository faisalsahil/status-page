class ComponentsController < ApplicationController
  before_filter :authenticate_user!, except:[:update, :update_by_email]

  def index
  	# @components = Component.where("user_id=?",current_user.id)
    @components = current_user.try(:components)
    @statuses = current_user.statuses
    if params[:notice].present?
      flash[:notice] = params[:notice]
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    @component = Component.new(params[:component])
  end

  def create
    #return render json: params.inspect
    # puts '=='*80
    # puts params[:status_id]
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

    		redirect_to components_path, :success => "Component added!"
    	else
    		render :new
    	end
    end
  end

  def show
    @component = Component.find(params[:id])
    @incidents = @component.try(:incidents)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @component = Component.find(params[:id])
  end

  def update
    
  end	
  
  def update_component
  	@component = Component.find(params[:id])
    @component.description = params[:description]
    @component.name = params[:name]
    @component.status_id = params[:statusId]
    @component.save!
  	return render :json=> true
  end

  

  def destroy
    @component = Component.find(params[:id]) 
    incisOfSelectedComponent = Incident.where("component_id = ?", params[:id])
    incisOfSelectedComponent.destroy_all

    @component.destroy

    respond_to do |format|
      format.html { redirect_to components_url, success: 'Component was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
