class CreateAdvertisements < ActiveRecord::Migration[7.0]
  def change
    create_table :advertisements do |t|
      t.string :title
      t.string :description
      t.references :user, null: false
      t.string :location
      t.string :category

      t.timestamps
    end

    add_foreign_key :advertisements, :users
  end
end
