# spec/requests/daily_tasks_spec.rb
require 'rails_helper'

RSpec.describe "DailyTasks", type: :request do
  let(:building) { create(:building) }
  let(:service) { create(:service, building: building) }
  let(:user) { create(:user) }
  let(:non_participating_user) { create(:user) }
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/task_image.jpg"), "image/jpeg") }

  before do
    create(:service_participant, :supervisor, user: user, service: service)
    login_as(user, scope: :user)
  end

  describe "PATCH /daily_tasks/:id" do
    context "when supervisor uploads a valid JPEG" do
      it "attaches the file and marks the task as completed" do
        daily_task = service.daily_tasks.first

        patch daily_task_path(daily_task), params: {
          daily_task: { file: file }
        }

        expect(response).to have_http_status(:ok)

        daily_task.reload

        expect(daily_task.file).to be_attached
        expect(daily_task.status).to eq("completed")
        expect(daily_task.completed_by).to eq(user)
      end
    end

    context "when supervisor is not a participant" do
      before do
        login_as(non_participating_user, scope: :user)
      end

      it "does not allow the user to update the daily task and returns forbidden" do
        daily_task = service.daily_tasks.first

        patch daily_task_path(daily_task), params: {
          daily_task: { file: file }
        }

        daily_task.reload

        expect(response).to have_http_status(:forbidden)
        expect(json_response["error"]).to eq("No autorizado")
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
