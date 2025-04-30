class DailyTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_task
  before_action :authorize_supervisor!

  def update
    if @daily_task.update(daily_task_params.merge(completed_by: current_user))
      render json: @daily_task, status: :ok
    else
      render json: { errors: @daily_task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_daily_task
    @daily_task = DailyTask.find(params[:id])
  end

  def authorize_supervisor!
    @service = @daily_task.service # Obtenemos el service desde la task
    participant = @service.service_participants.find_by(user: current_user)
    unless participant&.role == "supervisor"
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end

  def daily_task_params
    params.require(:daily_task).permit(:file)
  end
end
