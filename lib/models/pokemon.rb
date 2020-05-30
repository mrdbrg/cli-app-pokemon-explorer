class Pokemon < ActiveRecord::Base
  has_many :battles
  has_many :pokemon_locations
  has_many :locations, through: :pokemon_locations
end