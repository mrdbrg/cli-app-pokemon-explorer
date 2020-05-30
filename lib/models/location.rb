class Location < ActiveRecord::Base
  has_many :pokemon_locations
  has_many :pokemons, through: :pokemon_locations
end