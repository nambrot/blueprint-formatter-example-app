class PatientsController < ApplicationController
  respond_to :json

  def create
    @patient = Patient.create create_patient_params
    respond_with @patient
  end

  private

  def create_patient_params
    params.require(:patient).permit(:name)
  end

end
