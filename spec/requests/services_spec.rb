# spec/requests/services_spec.rb
require 'rails_helper'

RSpec.describe "Services", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:building) { create(:building) }

  before do
    login_as(admin, scope: :user)
  end

  describe "GET /buildings/:building_id/services" do
    context "when the user is an admin" do
      it "returns all services for the building" do
        create_list(:service, 3, building: building)

        get building_services_path(building)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
      end
    end

    context "when the user is a client" do
      let(:client) { create(:user, :client) }

      before do
        login_as(client, scope: :user)
        create(:building_client, user: client, building: building)
      end

      it "returns all services for the building" do
        create_list(:service, 3, building: building)

        get building_services_path(building)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
      end
    end

    context "when the user is basic" do
      let(:basic_user) { create(:user) }  # Usuario con rol 0 (básico)

      before do
        login_as(basic_user, scope: :user)
        # Crear servicios y asignar uno al usuario básico
        service1 = create(:service, building: building)
        service2 = create(:service, building: building)
        service3 = create(:service, building: building)

        # Asignamos al usuario básico a uno de los servicios
        create(:service_participant, user: basic_user, service: service1)
      end

      it "returns only the services assigned to the user" do
        get building_services_path(building)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(1)  # Debería ver solo el servicio al que está asignado

        # Verificamos que el servicio devuelto sea el que está asignado al usuario básico
        expect(json_response.first["id"]).to eq(Service.first.id)  # Debería ser el servicio1
      end
    end
  end

  describe "POST /buildings/:building_id/services" do
    context "when the user is an admin" do
      let(:admin) { create(:user, :admin) }
      let(:building) { create(:building) }

      before { login_as(admin, scope: :user) }

      it "creates a new service for the building" do
        service_params = {
          service: {
            name: "New Service",
            description: "Test service",
            start_date: "2025-05-01",
            end_date: "2025-05-05"
          }
        }

        expect {
          post building_services_path(building), params: service_params
        }.to change(Service, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response["name"]).to eq("New Service")
      end
    end

    context "when the user is a client" do
      let(:client) { create(:user, :client) }

      before do
        login_as(client, scope: :user)
        create(:building_client, user: client, building: building)
      end

      it "does not allow creation of a service" do
        service_params = {
          service: {
            name: "Client Test Service",
            description: "Should not be allowed",
            start_date: "2025-05-01",
            end_date: "2025-05-05"
          }
        }

        post building_services_path(building), params: service_params

        expect(response).to have_http_status(:forbidden) # o :unauthorized si prefieres
        expect(Service.count).to eq(0)
      end
    end

    context "when the user is a client" do
      let(:user) { create(:user) }

      before do
        login_as(user, scope: :user)
        create(:building_client, user: user, building: building)
      end

      it "does not allow creation of a service" do
        service_params = {
          service: {
            name: "Client Test Service",
            description: "Should not be allowed",
            start_date: "2025-05-01",
            end_date: "2025-05-05"
          }
        }

        post building_services_path(building), params: service_params

        expect(response).to have_http_status(:forbidden) # o :unauthorized si prefieres
        expect(Service.count).to eq(0)
      end
    end
  end

  describe "PATCH //services/:id" do
    let(:building) { create(:building) }
    let(:service) { create(:service, building: building, name: "Old Name") }

    context "when the user is an admin" do
      let(:admin) { create(:user, :admin) }

      before do
        login_as(admin, scope: :user)
      end

      it "updates the service" do
        patch service_path(service), params: {
          service: { name: "Updated Name" }
        }

        expect(response).to have_http_status(:ok)
        expect(json_response["name"]).to eq("Updated Name")
        expect(service.reload.name).to eq("Updated Name")
      end
    end

    context "when the user is a client" do
      let(:client) { create(:user, :client) }

      before do
        create(:building_client, user: client, building: building)
        login_as(client, scope: :user)
      end

      it "returns forbidden" do
        patch service_path(service), params: {
          service: { name: "Malicious Update" }
        }

        expect(response).to have_http_status(:forbidden)
        expect(service.reload.name).to eq("Old Name")
      end
    end

    context "when the user is a basic user" do
      let(:basic_user) { create(:user, :basic) }

      before do
        login_as(basic_user, scope: :user)
      end

      it "returns forbidden" do
        patch service_path(service), params: {
          service: { name: "Malicious Update" }
        }

        expect(response).to have_http_status(:forbidden)
        expect(service.reload.name).to eq("Old Name")
      end
    end
  end

  describe "DELETE /services/:id" do
    let(:building) { create(:building) }
    let!(:service) { create(:service, building: building) }

    context "when the user is an admin" do
      let(:admin) { create(:user, :admin) }

      before { login_as(admin, scope: :user) }

      it "deletes the service" do
        expect {
          delete service_path(service)
        }.to change(Service, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user is a client" do
      let(:client) { create(:user, :client) }

      before do
        create(:building_client, user: client, building: building)
        login_as(client, scope: :user)
      end

      it "returns forbidden" do
        expect {
          delete service_path(service)
        }.not_to change(Service, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the user is a basic user" do
      let(:basic_user) { create(:user) }

      before { login_as(basic_user, scope: :user) }

      it "returns forbidden" do
        expect {
          delete service_path(service)
        }.not_to change(Service, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  private

  def json_response
    JSON.parse(response.body)
  end
end
