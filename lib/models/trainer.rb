class Trainer < ActiveRecord::Base
  belongs_to :pokemon
  has_many :battles
  has_many :pokemons, through: :battles

  def self.new_trainer
    prompt = TTY::Prompt.new
    greeting_newbie = "
    ***********************************************************************
    ******                                                           ******
    ******  So you think you got what it takes to be the very best?  ******
    ******                                                           ******
    ***********************************************************************
    "
    user_input = prompt.select(greeting_newbie, ["Yes, I do.", "Of course. I will prove it to you!", "I changed my mind."])
    if user_input == "Yes, I do."
      puts "
      *************************************
      ***  I will be the judge of that! ***
      *************************************
      "
      self.ask_name_and_create_trainer
    elsif user_input == "Of course. I will prove it to you!"
      puts "
      ***************************************************************************
      ****  We've met people like you before. Let's see how tough you are... ****
      ***************************************************************************
      "
      self.ask_name_and_create_trainer
    elsif user_input == "I changed my mind."
      puts "
      **********************************************************************
      ***  I didn't think so. Come back when you get out of your dipers. ***
      **********************************************************************
      "
    end
  end

  def self.ask_name_and_create_trainer
    prompt = TTY::Prompt.new
    trainer_name = prompt.ask("How should we call you?")
    Trainer.create(name: trainer_name.capitalize)
  end

  def self.login_trainer
    prompt = TTY::Prompt.new
    trainer_name = prompt.ask("What is your trainer name?")
    found_trainer = Trainer.find_by(name: trainer_name.capitalize)
    if found_trainer 
      return found_trainer
    else 
      puts "
      *********************************************************************************
      *** Hey, I remember you! You're not a trainer... you're from the Team Rocket! ***
      ***                            GET OUT OF HERE!!!!                            ***
      *********************************************************************************"
    end 
  end
end