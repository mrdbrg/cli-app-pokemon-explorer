class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |t|
      t.integer :pokemon_id
      t.integer :trainer_id
      t.integer :location_id
    end
  end
end
