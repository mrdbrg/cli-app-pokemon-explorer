class Interface 
  attr_accessor :prompt, :user, :user_current_location
  @@trainer_pepTalk = ["Go catch them all!", "It's great to see you again."]
  @@newbie_pepTalk = ["I hope you know what you're doing.", "Are you still there? ...chop chop... the time is ticking!", "Don't waste your time. You got work to do."]

  def initialize
    @prompt = TTY::Prompt.new
  end

  def greet
    puts "Welcome to the Pokemon world!"
  end

  def choose_new_trainer_or_check_inventory
    main_menu_msg = "
    ================================================================================
    ==                                                                            ==
    ==      Existing trainers: Go to your inventory and check your progress       ==
    ==                                                                            ==
    ==             New trainers: Start exploring the Pokemon world!               ==
    ==                                                                            ==
    ================================================================================
    "
    answer = prompt.select(main_menu_msg, ["Check Inventory", "New Trainer"])
    trainer_info = {
      trainer: nil,
      isItNew: true
    }
    if answer == "Check Inventory"
      current_trainer = Trainer.login_trainer
      trainer_info[:trainer] = current_trainer
      trainer_info[:isItNew] = false
      trainer_info
    elsif answer == "New Trainer"
      new_trainer = Trainer.new_trainer
      trainer_info[:trainer] = new_trainer
      trainer_info
    end
  end

  def welcome_back
    puts "Welcome back, #{user.name}! #{@@trainer_pepTalk.sample}"
    self.trainer_chooses_town
    self.main_menu
  end

  def welcome_newbie
    puts "Welcome to the game, #{user.name}! #{@@newbie_pepTalk.sample}"
    self.trainer_chooses_pokemon
    self.trainer_chooses_town
    self.main_menu
  end

  def trainer_chooses_pokemon
    poke_choices =  {"Fire" => "Charmander", "Grass" => "Bulbasaur", "Water" => "Squirtle"}
    type_choice = prompt.select("Time to choose ", poke_choices.keys) 
    user.pokemon = Pokemon.find_by(name: poke_choices[type_choice])
    user.save
  end

  def trainer_chooses_town
    town_choices = Location.where.not(town_name: "Pallet Town").map {|town| town.town_name}
    choice = prompt.select("Please, choose your location!", town_choices) 
    self.user_current_location = Location.find_by(town_name: choice)
  end

  def main_menu
    # MAIN MENY GENERIC OPTIONS
    # 1) CHECK USER'S SCORES
    # 2) EDIT POKEMONS
    # 3) START EXPLORING => start_exploring
    self.start_exploring
    puts "DISPLAY OTHER OPTIONS"
    
    # binding.pry
    # self.animation
  end

  def find_wild_pokemon
    
    Pokemon.all.where(location_id: self.user_current_location.id).sample
    
  end

  def start_battle
   choice = prompt.select("WANNA FIGHT? ", ["LET'S BATTLE!", "No, I don't want to"]) 
   if choice == "LET'S BATTLE!"
   puts "POKEMONS ARE BATTLING "
   elsif choice == "No, I don't want to"
  self.no_battle
   end 
  end 

  def no_battle 
    battle_choice = prompt.select("Would you like to continue exploring this town?", ["Yes plz!", "No, I want to visit another town!"]) 
    if battle_choice == "Yes plz!"
      self.start_exploring
    elsif battle_choice == "No, I want to visit another town!"
      puts "GO BACK TO CHOOSE THE TOWN"
    end
  end 

  def yes_battle
    #compare
    self.find_wild_pokemon 
    self.user.pokemon
    #BATTLE HAPPENS
    #Battle.new 
  end 

  def start_exploring
    # START EXPLORING TOWN
    puts "==================================================="
    puts ""
    puts "Welcome to #{self.user_current_location.town_name}!"
    puts ""
    puts "==================================================="
   sleep 3
    # SHOW OTHER POKEMONS TO USER
    puts "==================================================="
    puts ""
    puts "YOU FOUND A POKEMON #{self.find_wild_pokemon.name}!"
    puts ""
    puts "==================================================="
    self.start_battle
  end

end