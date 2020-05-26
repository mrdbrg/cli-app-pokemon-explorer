Pokemon.destroy_all
Trainer.destroy_all
Battle.destroy_all
Location.destroy_all

# Faker::Name.name  
# Faker::Games::Pokemon.name 

location1 = Location.create(town_name: Faker::Games::Pokemon.location)

3.times do 
  Pokemon.create(
  name: Faker::Games::Pokemon.name, 
  attack: rand(3..12),
  defense: rand(3..12),
  hp: 30,
  location_id: location1.id
)
end

# trainer1 = Trainer.create(name: "Anastasia", pokemon_id: poke3.id)

# battle1 = Battle.create(pokemon_id: poke1.id, trainer_id: trainer1.id)



