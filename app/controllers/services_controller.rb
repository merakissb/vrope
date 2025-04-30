class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [ :index, :create ]
  before_action :set_service, only: [ :show, :update, :destroy ]
  before_action :authorize_admin!, only: [ :create, :update, :destroy ]

  def create
    @service = @building.services.build(service_params)

    if @service.save
      render json: @service, status: :created
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @services = accessible_services_for(current_user, @building)
    render json: @services
  end

  def show
    if can_view_service?(current_user, @service)
      render json: @service
    else
      render json: { error: "No tienes permiso para ver este servicio" }, status: :forbidden
    end
  end

  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    head :no_content
  end

  private

  def authorize_admin!
    render json: { error: "No autorizado" }, status: :forbidden unless current_user.admin?
  end

  def service_params
    params.require(:service).permit(:name, :description, :start_date, :end_date)
  end

  def set_building
    @building = Building.find(params[:building_id])
  end

  def set_service
    @service = Service.find(params[:id])
  end

  def accessible_services_for(user, building)
    return building.services if user.admin?
    return building.services if user.client? && user.accessible_buildings.include?(building)
    user.services.where(building: building)
  end

  def can_view_service?(user, service)
    user.admin? || user.services.include?(service)
  end
end
