require 'rails_helper'

RSpec.describe PatientsController,
  :apidoc, type: :controller,
  resource_group: 'API V1',
  resource: 'Patients [/patients]' do
  render_views

  describe '#create',
    action: 'Creating a patient [POST]',
    action_description: 'This endpoint allows you to create a Patient' do

    let(:patient_params) { { name: param_name } }
    let(:create_patient) { post :create, patient: patient_params, format: :json }

    context 'with an invalid name' do
      let(:param_name) { nil }

      it 'fails to create a patient' do
        expect { create_patient }.not_to change { Patient.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with a valid name' do
      let(:param_name) { 'valid name' }

      it 'succeeds in creating a patient' do
        expect { create_patient }.to change { Patient.count }
        expect(response).to have_http_status(:created)
      end

      context 'that is already taken by another patient' do
        let!(:other_patient) { Patient.create(name: param_name) }

        it 'fails to create a patient' do
          expect { create_patient }.not_to change { Patient.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
