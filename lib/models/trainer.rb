class Trainer < ActiveRecord::Base
  belongs_to :pokemon
  has_many :battles
  has_many :pokemons, through: :battles
end