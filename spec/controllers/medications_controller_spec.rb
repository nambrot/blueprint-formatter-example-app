require 'rails_helper'

RSpec.describe MedicationsController,
  :apidoc, type: :controller,
  resource_group: 'API V1',
  resource: 'Medications [/patients/:id/medications]' do
  render_views

  let(:patient) { Patient.create(name: 'patientname', status: patient_status) }
  let(:patient_status) { 'healthy' }
  let(:param_patient_id) { patient.id }
  let(:medication_params) { { name: param_name } }
  let(:param_name) { nil }

  describe '#index',
    action: 'Retrieve all Medications [GET]',
    action_description: "This endpoint allows you to get all medications of a patient" do

    let!(:medication) { patient.medications.create name: 'existing-name' }
    let(:retrieve_medications) { get :index, patient_id: param_patient_id, format: :json }

    it 'retrievs the patients medications' do
      retrieve_medications
      expect(JSON.parse(response.body).length).to eql 1
      expect(response).to have_http_status(:ok)
    end

    context 'with an invalid patient_id' do
      let(:param_patient_id) { 'invalid_id' }

      it 'fails' do
        retrieve_medications
        expect(response).to have_http_status(:not_found)
      end
    end

  end

  describe '#update',
    action: 'Change a given medication [PATCH]',
    action_description: "This endpoint allows you to change the name of a medication " do

    let!(:medication) { patient.medications.create name: 'existing-name' }
    let(:param_medication_id) { medication.id }
    let(:update_medication) { patch :update, patient_id: param_patient_id, id: param_medication_id, medication: medication_params, format: :json }

    shared_examples 'fails to update medication' do
      it 'fails to update medication' do
        expect { update_medication }.not_to change { medication.reload.name }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    shared_examples 'succeeds in updating a medication' do
      it 'succeeds in updating a medication' do
        expect { update_medication }.to change { medication.reload.name }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with an invalid name' do
      let(:param_name) { nil }
      include_examples 'fails to update medication'
    end

    context 'with a valid name' do
      let(:param_name) { 'valid name' }

      include_examples 'succeeds in updating a medication'

      context 'that is already taken by another medication' do
        let!(:other_medication) { patient.medications.create(name: param_name) }

        include_examples 'fails to update medication'
      end

      context 'when the patient is pre-surgery' do
        let(:patient_status) { 'pre-surgery' }

        context 'and the med name is Aspirin' do
          let(:param_name) { 'Aspirin' }

          include_examples 'fails to update medication'
        end

        context 'and the med name is Tylenol' do
          let(:param_name) { 'Tylenol' }

          include_examples 'succeeds in updating a medication'
        end
      end
    end

    context 'with invalid patient_id' do
      let(:param_patient_id) { 'invalid' }

      it 'fails' do
        update_medication
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create',
    action: 'Creating a new medication for a patient [POST]',
    action_description: "This endpoint allows you to create a medication " \
     "for a given patient when passing valid parameters. Some medications are " \
     "not allowed for some patients." do

    let(:create_medication) { post :create, patient_id: param_patient_id, medication: medication_params, format: :json }

    shared_examples 'fails to create a medication' do
      it 'fails to create a medication' do
        expect { create_medication }.not_to change { Medication.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    shared_examples 'succeeds in creating a medication' do
      it 'succeeds in creating a medication' do
        expect { create_medication }.to change { Medication.count }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with an invalid name' do
      let(:param_name) { nil }

      include_examples 'fails to create a medication'
    end

    context 'with a valid name' do
      let(:param_name) { 'valid name' }

      include_examples 'succeeds in creating a medication'

      context 'that is already taken by another medication' do
        let!(:other_medication) { patient.medications.create(name: param_name) }

        include_examples 'fails to create a medication'
      end

      context 'when the patient is pre-surgery' do
        let(:patient_status) { 'pre-surgery' }

        context 'and the med name is Aspirin' do
          let(:param_name) { 'Aspirin' }

          include_examples 'fails to create a medication'
        end

        context 'and the med name is Tylenol' do
          let(:param_name) { 'Tylenol' }

          include_examples 'succeeds in creating a medication'
        end
      end
    end

    context 'with invalid patient_id' do
      let(:param_patient_id) { 'invalid' }

      it 'fails' do
        create_medication
        expect(response).to have_http_status(:not_found)
      end
    end
  end

end
