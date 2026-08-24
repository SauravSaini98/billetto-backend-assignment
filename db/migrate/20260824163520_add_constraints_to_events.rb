class AddConstraintsToEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :events, :title, false
    change_column_null :events, :external_id, false
    change_column_null :events, :start_at, false
    
    # Adding a unique index to external_id to prevent duplicate ingestion at the DB level
    add_index :events, :external_id, unique: true unless index_exists?(:events, :external_id)
  end
end
