class ServiceParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service
  before_action :authorize_admin!, only: [ :create, :show ]
  before_action :authorize_read_access!, only: [ :index, :show ]

  def index
    @participants = @service.service_participants
    render json: @participants
  end

  def show
    @participant = @service.service_participants.find(params[:id])
    render json: @participant
  end

  def create
    user = User.find_by(id: participant_params[:user_id])

    unless user
      return render json: { error: "Usuario no encontrado" }, status: :unprocessable_entity
    end

    @participant = @service.service_participants.new(participant_params)

    if @participant.save
      render json: @participant, status: :created
    else
      render json: @participant.errors, status: :unprocessable_entity
    end
  end

  private

  def set_service
    @service = Service.find(params[:service_id])
  end

  def participant_params
    params.require(:service_participant).permit(:user_id, :role)
  end

  def authorize_admin!
    render json: { error: "No autorizado" }, status: :forbidden unless current_user.admin?
  end

  def authorize_read_access!
    return if current_user.admin?

    unless current_user.has_access_to_building?(@service.building_id)
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end
end
