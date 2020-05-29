class Battle < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :trainer


  def self.trainer_wins
    
  end

  # ========================================================================
  # Trainer's pokemon
  # Battle.first.trainer.pokemons.first
  # ========================================================================
  # Current battle associated with the trainer and a random pokemon id
  # Battle.first
  # ========================================================================
end

