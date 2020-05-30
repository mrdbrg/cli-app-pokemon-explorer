class Trainer < ActiveRecord::Base
  has_many :battles
  has_many :battled_pokemons, through: :battles, class_name: "Pokemon"
  has_many :own_pokemons
  has_many :pokemons, through: :own_pokemons

  def self.new_trainer
    prompt = TTY::Prompt.new
    user_input = prompt.select(Interactivity.greeting_newbie, ["Yes, I do.", "Of course. I will prove it to you!", "I changed my mind."])
    if user_input == "Yes, I do."
      Interactivity.newbie_greeting_intrigued
      sleep 1
      self.ask_name_and_create_trainer
    elsif user_input == "Of course. I will prove it to you!"
      Interactivity.newbie_greeting_arrogant
      sleep 1
      self.ask_name_and_create_trainer
    elsif user_input == "I changed my mind."
      Interactivity.newbie_greeting_gave_up
      sleep 1
    end
  end

  def self.ask_name_and_create_trainer
    prompt = TTY::Prompt.new
    trainer_name = prompt.ask(Interactivity.yourNameIs)
    Trainer.create(name: trainer_name.capitalize)
  end

  def self.login_trainer
    prompt = TTY::Prompt.new
    trainer_name = prompt.ask(Interactivity.trainerName)
    found_trainer = Trainer.find_by(name: trainer_name.capitalize)
    if found_trainer 
      return found_trainer
    else 
      Interactivity.teamRocket
    end 
  end
end