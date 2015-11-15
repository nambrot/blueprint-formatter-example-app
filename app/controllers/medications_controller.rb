class MedicationsController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do
    render json: {}, status: :not_found
  end

  def index
    @medications = patient.medications
    respond_with @medications
  end

  def create
    @medication = patient.medications.create medication_create_params
    respond_with patient, @medication
  end

  def update
    @medication = patient.medications.find(params[:id])
    @medication.update medication_update_params
    respond_with @medication
  end

  private

  def patient
    @patient ||= Patient.find(params[:patient_id])
  end

  def medication_create_params
    params.require(:medication).permit(:name)
  end

  def medication_update_params
    params.require(:medication).permit(:name)
  end

end
