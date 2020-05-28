class Interface 
    attr_accessor :prompt, :user, :user_current_location
    @@trainer_pepTalk = ["Go catch them all!", "It's great to see you again."]
    @@newbie_pepTalk = ["I hope you know what you're doing.", "Are you still there? ...chop chop... the time is ticking!", "Don't waste your time. You got work to do."]
    @@isItInTown = false

    def initialize
        @prompt = TTY::Prompt.new
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                              LOGIN SECTION                                        ====
    # ====                                                                                   ====
    # ===========================================================================================

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
        answer = prompt.select(main_menu_msg, ["Manage Inventory", "New Trainer", "Quit"])
        trainer_info = {
            trainer: nil,
            isItNew: true
        }
        if answer == "Manage Inventory"
            current_trainer = Trainer.login_trainer
            trainer_info[:trainer] = current_trainer
            trainer_info[:isItNew] = false
            trainer_info
        elsif answer == "New Trainer"
            new_trainer = Trainer.new_trainer
            trainer_info[:trainer] = new_trainer
            trainer_info
        else
            puts "Goodbye"
        end
    end 

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                              WELCOME SECTION                                      ====
    # ====                                                                                   ====
    # ===========================================================================================

    def greet
        puts "Welcome to the Pokemon world!"
    end

    def welcome_back
        puts "Welcome back, #{user.name}! #{@@trainer_pepTalk.sample}"
        self.main_menu
        # self.trainer_chooses_town
    
    end

    def welcome_newbie
        puts "Welcome to the game, #{user.name}! #{@@newbie_pepTalk.sample}"
        self.main_menu
        # self.trainer_chooses_pokemon
        # self.trainer_chooses_town
        
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                      MAIN MENU / TRAINER CHOICES SECTION                          ====
    # ====                                                                                   ====
    # ===========================================================================================

    def main_menu
        options = ["Start Exploring", "Check Inventory", "Check Score"]
        choice = prompt.select("What would you like to do?", options) 
        
        if choice == "Start Exploring"
            self.trainer_chooses_town
            self.exploring_town
        elsif choice == "Check Inventory"
            puts "MANAGE INVENTORY - CHANGE POKEMONS AROUND"
        else
            puts "CHECK YOUR SCORE"
        end
    end 

    # ===========================================================================================
    # ====                                CHOOSE POKEMON                                     ====
    # ===========================================================================================

    def trainer_chooses_pokemon
        poke_choices =  {"Fire" => "Charmander", "Grass" => "Bulbasaur", "Water" => "Squirtle"}
        type_choice = prompt.select("Time to choose ", poke_choices.keys) 
        user.pokemon = Pokemon.find_by(name: poke_choices[type_choice])
        user.save
    end

    # ===========================================================================================
    # ====                                  CHOOSE TOWN                                      ====
    # ===========================================================================================

    def trainer_chooses_town
        town_choices = Location.where.not(town_name: "Pallet Town").map {|town| town.town_name}
        menu_options = "Which town would you like to explore first?"
        if self.user_current_location
            town_choices.push("Check Score")
            menu_options = "Would you like to explore more or check your score?"
        end
    
        choice = prompt.select(menu_options, town_choices) 
        self.user_current_location = Location.find_by(town_name: choice)
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                           EXPLORING TOWN SECTION                                  ====
    # ====                                                                                   ====
    # ===========================================================================================

    def find_wild_pokemon
        Pokemon.all.where(location_id: self.user_current_location.id).sample
    end

    def exploring_town
        if @@isItInTown != true
            Interactivity.welcome_to_town(user_current_location)
            @@isItInTown = true
        end
        Interactivity.walking_in_town
        Interactivity.found_pokemon(find_wild_pokemon)
        self.start_battle
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                               BATTLE SECTION                                      ====
    # ====                                                                                   ====
    # ===========================================================================================

    def start_battle
        choice = prompt.select("Would you like to fight #{find_wild_pokemon.name}?", ["Yes, Let's BATTLE!", "No, I don't wanna battle."]) 
        if choice == "Yes, Let's BATTLE!"
            puts "RUNS BATTLE LOGIC FUNCTION"
        elsif choice == "No, I don't wanna battle."
            self.trainer_chooses_town   
        end 
    end 

    def refuses_battle 
        options = ["Yes, I wanna keep exploring.", "No, I want to visit another town!"]
        battle_choice = prompt.select("Would you like to continue exploring this town?", options) 
        if battle_choice == "Yes, I wanna keep exploring."
            self.exploring_town
        elsif battle_choice == "No, I want to visit another town!"
            puts "GO BACK TO CHOOSE THE TOWN"
        end
    end 

    self.find_wild_pokemon 
    self.user.pokemon

    def accepts_battle
        user_pokemon = self.user.pokemon
        wild_pokemon = self.find_wild_pokemon
      
        while user_pokemon.hp > 0 && wild_pokemon.hp > 0
          if user_pokemon.attack > wild_pokemon.attack
            puts "You got the upper hand!"
            self.battling(wild_pokemon, user_pokemon)
          else
            # binding.pry
            puts "This is gonna be tough!"
            self.battling(user_pokemon, wild_pokemon)
          end
        end
    end 
  
    def battling(lowerhand, upperhand)
        small_defense = ["Nice, dodge!!", "Easy Peasy", "It's your chance... counter attack!", "Wait for the right moment... now!", "That tickled"]
        greater_defense = [ "Nice, dodge!!", "That's tough, but we can handle it!", "Counter attack!! Counter attack!!", "Don't give up!", "You got hit really hard.", "Be careful!"]

        while lowerhand.hp > 0 && upperhand.hp > 0
            sleep 1
            if upperhand.defense > lowerhand.defense
                puts small_defense.sample
                if lowerhand.hp > 10 
                    lowerhand.hp -= 10 
                    upperhand.hp -= 2
                elsif  
                    lowerhand.hp = 0 
                end
            else
                puts greater_defense.sample
                if lowerhand.hp > 5 
                    lowerhand.hp -= 5 
                    upperhand.hp -= 2
                elsif 
                    lowerhand.hp = 0 
                end 
            end
        end 
        if lowerhand.hp = 0
            puts "#{upperhand.name} WON!"
        end 
    end
end