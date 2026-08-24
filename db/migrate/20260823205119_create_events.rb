class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :external_id
      t.integer :vote_count
      t.datetime :start_at
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
