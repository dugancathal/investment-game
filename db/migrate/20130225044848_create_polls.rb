class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.references :ticker
      t.float :value, default: 0

      t.timestamps
    end
    add_index :polls, :ticker_id
  end
end
