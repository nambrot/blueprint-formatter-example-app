class Patient < ActiveRecord::Base
  has_many :medications

  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w{healthy pre-surgery post-surgery rehab} }

  def pre_surgery?
    status == 'pre-surgery'
  end
end
