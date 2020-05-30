class Trainer < ActiveRecord::Base
  belongs_to :pokemon
  has_many :battles
  has_many :pokemons, through: :battles

  def self.new_trainer
    prompt = TTY::Prompt.new
    user_input = prompt.select(Interactivity.greeting_newbie, ["Yes, I do.", "Of course. I will prove it to you!", "I changed my mind."])
    if user_input == "Yes, I do."
      sleep(1)
      Interactivity.newbie_greeting_intrigued
      self.ask_name_and_create_trainer
    elsif user_input == "Of course. I will prove it to you!"
      sleep(1)
      Interactivity.newbie_greeting_arrogant
      self.ask_name_and_create_trainer
    elsif user_input == "I changed my mind."
      sleep(1)
      Interactivity.newbie_greeting_gave_up
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