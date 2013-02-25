class CreateProfits < ActiveRecord::Migration
  def change
    create_table :profits do |t|
      t.float :value, default: 0
      t.references :player
      t.references :ticker

      t.timestamps
    end
    add_index :profits, :player_id
    add_index :profits, :ticker_id
  end
end
