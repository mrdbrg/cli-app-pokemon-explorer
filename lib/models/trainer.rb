class Trainer < ActiveRecord::Base
  has_many :battles
  has_many :pokemons, through: :battles

  # ========================================================================
  # Trainer's instance
  # Trainer.first
  # ========================================================================
end