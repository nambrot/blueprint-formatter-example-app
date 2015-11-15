class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.string :name
      t.integer :patient_id

      t.timestamps null: false
    end

    add_index :medications, [:name, :patient_id], unique: true
  end
end
