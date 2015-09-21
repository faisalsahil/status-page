class MaintenanceController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @components = current_user.components
    @maintenances = Maintenance.where(component_id: @components)
    respond_to do |format|
      format.html
    end
  end

  def edit
    @maintenance = Maintenance.find(params[:id])
    @components = Component.all
  end

  def show
    @maintenance = Maintenance.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def update
    @maintenance = Maintenance.find(params[:id])

    respond_to do |format|
      if @maintenance.update_attributes(params[:maintenance])
        format.html { redirect_to @maintenance, success: 'Maintenance credentials were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def create

    if current_user.components.find_by_id(params[:maintenance][:component_id]).maintenance.present?
        redirect_to new_maintenance_path, :alert => "Maintenance already scheduled for selected component!"
    else
      
      component = Component.find(params[:maintenance][:component_id])
      
      @maintenance = component.build_maintenance(params[:maintenance])
    
      if @maintenance.save
        flash[:success] = "Maintenance Scheduled!"
        redirect_to maintenance_index_path
      else
        flash[:alert] = "End date cannot be older than start date!"
        redirect_to new_maintenance_path
      end
    end
  end

  def destroy
    @maintenance = Maintenance.find(params[:id])
    @maintenance.destroy

    flash[:success] = "Maintenance removed successfully!"
    redirect_to maintenance_index_path
  end

  def new
    @maintenance = Maintenance.new(params[:maintenance])
    @components = Component.where("user_id=?",current_user.id)
  end
end
