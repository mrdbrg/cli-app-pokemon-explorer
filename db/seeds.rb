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
  attack: rand(3..7),
  defense: rand(3..8),
  hp: 30,
  location: Location.find_by(town_name: "Pallet Town")
)
end  

10.times do 
  Pokemon.create(
  name: Faker::Games::Pokemon.name, 
  attack: rand(3..7),
  defense: rand(4..8),
  hp: 30,
  location: Location.where.not(town_name: "Pallet Town").sample
)
end




