class CreateTrainers < ActiveRecord::Migration[5.2]
  def change
    create_table :trainers do |t|
      t.string :name
      t.integer :pokemon_id
      t.integer :wins
      t.integer :loses
    end
  end
end
