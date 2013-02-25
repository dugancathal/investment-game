class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :player
      t.references :ticker
      t.float :value, default: 0
      t.integer :multiplier, default: 0
      t.float :commission, default: -8.95
      t.string :type

      t.timestamps
    end
    add_index :contracts, :player_id
    add_index :contracts, :ticker_id
  end
end
