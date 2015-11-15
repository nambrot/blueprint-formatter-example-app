class Medication < ActiveRecord::Base
  belongs_to :patient

  validates :patient, presence: true
  validates :name, presence: true, uniqueness: { scope: :patient_id }
  validates :name, exclusion: { in: %w{Aspirin}, message: 'cannot be Aspirin when patient is pre-surgery' }, if: 'patient.pre_surgery?'
end
