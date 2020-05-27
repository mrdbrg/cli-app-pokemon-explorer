Pokemon.destroy_all
Trainer.destroy_all
Battle.destroy_all
Location.destroy_all

["Pallet Town", "Celadon City", "Viridian City", "Vermilion City"].each do |town|
   Location.create(town_name: town)
end 

["Charmander", "Bulbasaur", "Squirtle"].each do |pokemon|
  Pokemon.create(
  name: pokemon, 
  attack: rand(3..12),
  defense: rand(3..12),
  hp: 30,
  location: Location.find_by(town_name: "Pallet Town")
)
end  

10.times do 
  Pokemon.create(
  name: Faker::Games::Pokemon.name, 
  attack: rand(3..12),
  defense: rand(4..16),
  hp: 30,
  location: Location.where.not(town_name: "Pallet Town").sample
)
end

# trainer1 = Trainer.create(name: "Anastasia", pokemon_id: poke3.id)

# battle1 = Battle.create(pokemon_id: poke1.id, trainer_id: trainer1.id)



