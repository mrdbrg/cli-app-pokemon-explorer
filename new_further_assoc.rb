class Battle < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :trainer
end

class Trainer < ActiveRecord::Base
  has_many :battles
  has_many :battled_pokemons, through: :battles, class_name: "Pokemon"
  has_many :own_pokemons
  has_many :pokemons, through: :own_pokemons
end

# This is how we would retrieve battled_pokemons from Battle and pokemons from Own_pokemon
# ==> <instance_of_trainer>.battled_pokemons
# ==> <instance_of_trainer>.pokemons

class Pokemon < ActiveRecord::Base
  has_many :battles
  has_many :pokemon_locations
  has_many :locations, through: :pokemon_locations
end

class Location < ActiveRecord::Base
  has_many :pokemon_locations
  has_many :pokemons, through: :pokemon_locations
end