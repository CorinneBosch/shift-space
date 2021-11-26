class CreateOrganisations < ActiveRecord::Migration[6.1]
  def change
    create_table :organisations do |t|
      t.text :name, null: false, unqiue: true
      t.decimal :hourly_rate, null: false

      t.timestamps
    end
  end
end
