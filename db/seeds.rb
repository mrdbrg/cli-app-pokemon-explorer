Pokemon.destroy_all
Trainer.destroy_all
Battle.destroy_all
Location.destroy_all

# Faker::Name.name  
# Faker::Games::Pokemon.name 

poke1 = Pokemon.create(name: Faker::Games::Pokemon.name)
poke2 = Pokemon.create(name: Faker::Games::Pokemon.name)
poke3 = Pokemon.create(name: Faker::Games::Pokemon.name)

trainer1 = Trainer.create(name: "Anastasia", pokemon_id: poke3.id)

location1 = Location.create(town_name: Faker::Games::Pokemon.location, pokemon_id: poke1.id)

battle1 = Battle.create(pokemon_id: location1.pokemon_id, trainer_id: trainer1.id, location_id: location1.id)



