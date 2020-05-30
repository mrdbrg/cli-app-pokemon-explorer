class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |t|
      t.integer :pokemon_id
      t.integer :trainer_id
      t.boolean :trainer_results
    end
  end
end
