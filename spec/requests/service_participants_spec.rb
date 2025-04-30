# spec/requests/service_participants_spec.rb
require 'rails_helper'

RSpec.describe "ServiceParticipants", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:client) { create(:user, :client) }
  let(:service) { create(:service) }
  let(:participant_user) { create(:user) }
  let(:valid_attributes) { { rut: participant_user.rut, role: "supervisor" } }

  describe "POST /services/:service_id/participants" do
    context "when user is admin" do
      before do
        login_as(admin, scope: :user)
      end

      it "creates a new service participant" do
        expect {
          post service_participants_path(service), params: { service_participant: valid_attributes }
        }.to change(ServiceParticipant, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response).to include(
          "user_id" => participant_user.id,
          "role" => "supervisor"
        )
      end
    end

    context "when user is client" do
      before { login_as(client, scope: :user) }

      it "returns forbidden status" do
        post service_participants_path(service), params: { service_participant: valid_attributes }

        expect(response).to have_http_status(:forbidden)
      end

      it "does not create a service participant" do
        expect {
          post service_participants_path(service), params: { service_participant: valid_attributes }
        }.not_to change(ServiceParticipant, :count)
      end
    end
  end

  describe "GET /services/:service_id/participants" do
    context "when user is a admin" do
      before do
        login_as(admin, scope: :user)
      end

      it "returns a list of service participants" do
        create_list(:service_participant, 3, service: service)

        get service_participants_path(service)

        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(3)
        expect(json_response.first).to include("user_id", "role")
      end
    end

    context "when user is a client assigned to the building" do
      before do
        create(:building_client, user: client, building: service.building)
        create_list(:service_participant, 2, service: service)
        login_as(client, scope: :user)
      end

      it "returns participants of the service" do
        get service_participants_path(service)

        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(2)
        expect(json_response.first).to include("user_id", "role")
      end
    end

    context "when user is a client not assigned to the building" do
      before do
        create_list(:service_participant, 2, service: service)
        login_as(client, scope: :user)
      end

      it "returns forbidden status" do
        get service_participants_path(service)

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
