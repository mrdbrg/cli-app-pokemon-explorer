class Interface 
    attr_accessor :prompt, :user, :user_current_location
    @@trainer_pepTalk = ["Go catch them all!", "It's great to see you again."]
    @@newbie_pepTalk = ["Don't disappoint me.", "...chop chop... the clock is ticking!", "Don't waste time. You got work to do."]
    @@isItInTown = false
    @@wild_pokemon = nil

    def initialize
        @prompt = TTY::Prompt.new
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                              LOGIN SECTION                                        ====
    # ====                                                                                   ====
    # ===========================================================================================

    def choose_new_trainer_or_check_inventory
        answer = prompt.select(Interactivity.login_or_sign_up_menu_msg, ["Manage Inventory", "New Trainer", "Quit"])
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
            Interactivity.quit
        end
    end 

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                              WELCOME SECTION                                      ====
    # ====                                                                                   ====
    # ===========================================================================================

    def greet
        Interactivity.logo
    end

    def welcome(bool)
        bool == true ? Interactivity.welcome_newbie(user.name, @@newbie_pepTalk.sample) : Interactivity.welcome_back(user.name, @@trainer_pepTalk.sample)
        self.main_menu
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                      MAIN MENU / TRAINER CHOICES SECTION                          ====
    # ====                                                                                   ====
    # ===========================================================================================

    def main_menu
        menu_options = ["Start exploring", "Check Inventory", "Check Your Score", "Go to Pokemon Center", "Quit"]
        menu_prompt = Interactivity.mainMenu 
        
        if user.pokemon == nil
            menu_options.shift()
            menu_options.unshift("Choose a Pokemon and start exploring")
        elsif self.user_current_location
            menu_options.shift()
            menu_options.unshift("Keep Exploring")
        end
        
        choice = prompt.select(menu_prompt, menu_options) 
        if choice == "Start exploring" || choice == "Choose a Pokemon and start exploring" || choice == "Keep Exploring"
            self.trainer_chooses_pokemon if user.pokemon == nil 
            self.trainer_chooses_town
            self.exploring_town
        elsif choice == "Check Inventory"
            puts "MANAGE INVENTORY - CHANGE POKEMONS AROUND"
        elsif choice == "Go to Pokemon Center"
            self.pokemon_center
        elsif choice == "Check Your Score"
            puts "CHECK YOUR SCORE"
        else
            Interactivity.quit
        end
    end 

    # ===========================================================================================
    # ====                                CHOOSE POKEMON                                     ====
    # ===========================================================================================

    def trainer_chooses_pokemon
        choose_pokemon =  {"Fire" => "Charmander", "Grass" => "Bulbasaur", "Water" => "Squirtle"}
        type_choice = prompt.select(Interactivity.choose_pokemon, choose_pokemon.keys) 
        Interactivity.no_turning_back
        user.pokemon = Pokemon.find_by(name: choose_pokemon[type_choice])
        user.save
    end

    # ===========================================================================================
    # ====                                  CHOOSE TOWN                                      ====
    # ===========================================================================================

    def trainer_chooses_town
        town_choices = Location.where.not(town_name: "Pallet Town").map {|town| town.town_name}    
        choice = prompt.select(Interactivity.choose_town, town_choices) 
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
        @@wild_pokemon = find_wild_pokemon
        Interactivity.found_pokemon(@@wild_pokemon)
        self.start_battle
    end

    def keep_exploring?
        choices = ["Yes, I wanna keep exploring", "No, I want to stop for a minute"]
        menu_prompt = Interactivity.keepExploring 
        choice = prompt.select(menu_prompt, choices) 
        if choice == "Yes, I wanna keep exploring"
            self.exploring_town
        else
            self.main_menu
        end
    end

    # ===========================================================================================
    # ====                                                                                   ====
    # ====                               BATTLE SECTION                                      ====
    # ====                                                                                   ====
    # ===========================================================================================

    def start_battle
        self.go_to_pokemon_center? if user.pokemon.hp == 0
        choice = prompt.select(Interactivity.fightPokemon?(@@wild_pokemon.name), ["Let's BATTLE!", "No, I don't wanna battle."]) 
        if choice == "Let's BATTLE!"
            self.accepts_battle
        elsif choice == "No, I don't wanna battle."
            self.keep_exploring?  
        end 
    end 

    def accepts_battle
        win_or_lose = ["You got this!\n\n", "That one looks tough\n\n", "Don't make it angry\n\n", "Time to train!\n\n"]
        user_pokemon = self.user.pokemon

        while user_pokemon.hp > 0 && @@wild_pokemon.hp > 0
          if user_pokemon.attack >= @@wild_pokemon.attack
            puts win_or_lose.sample
            self.battling(@@wild_pokemon, user_pokemon)
          else
            puts win_or_lose.sample
            self.battling(user_pokemon, @@wild_pokemon)
          end
        end
    end 
  
    def battling(losing_side, upperhand)
        weak_defense = ["Nice, dodge!!\n\n", "Easy Peasy\n\n", "This is your chance... COUNTER ATTACK!\n\n", "Wait for the right moment... now!\n\n", "Ha! That tickled\n\n"]
        strong_defense = [ "Great reflexes!!\n\n", "That one is tough, but we can handle it.\n\n", "Counter attack!! Counter attack!!\n\n", "Don't give up!\n\n", "You got hit really hard.\n\n", "Be careful!\n\n"]

        while losing_side.hp > 0 && upperhand.hp > 0
            sleep 0.5
            if upperhand.defense >= losing_side.defense
                puts weak_defense.sample
                if losing_side.hp > 10 
                    losing_side.hp -= 10 
                    upperhand.hp -= 2
                    self.go_to_pokemon_center? if upperhand.hp == 0
                elsif  
                    losing_side.hp = 0 
                end
            else
                puts strong_defense.sample
                if losing_side.hp > 5 
                    losing_side.hp -= 5 
                    upperhand.hp -= 2
                    self.go_to_pokemon_center? if upperhand.hp == 0
                elsif 
                    losing_side.hp = 0 
                end 
            end
        end 
        if losing_side != user.pokemon && losing_side.hp == 0
            Interactivity.winner(upperhand.name)
            self.keep_exploring?
        end
        Interactivity.winner(upperhand.name)
        Interactivity.youLost
        go_to_pokemon_center?
    end

    def go_to_pokemon_center?
        choices = ["Yes, take me to the nearest Pokemon Center!", "No, let's just go home"]
        menu_prompt = Interactivity.needsHelp
        choice = prompt.select(menu_prompt, choices) 
        if choice == "Yes, take me to the nearest Pokemon Center!"
            self.pokemon_center
        else
            self.main_menu
        end
    end

    def pokemon_center(anything_else=nil, same_visit=nil)
        if anything_else == true
            choices = ["Thank you!", "Manage inventory", "Hey, do I know you?"]
            menu_prompt = Interactivity.howElseMayIhelpYou?
        else
            Interactivity.welcome_pokemon_center
            choices = ["My Pokemon isn't feeling well.", "Manage inventory", "It's fine. I changed my mind.", "Hey, do I know you?"]
            choices.shift() if user.pokemon.hp == 30
            if user.pokemon.hp == 0
                choices.shift()
                choices.unshift("Yes, please! * Hang in there buddy! *")
                choices.pop(3)
                menu_prompt = Interactivity.emergencyRoom(user.pokemon.name) 
            elsif same_visit == 1
                menu_prompt = Interactivity.mayIhelpYouByName(user.name) 
                choices = ["I think I'm all set. Thank you!", "Manage inventory", "My Pokemon isn't feeling well."]
                choices.pop() if user.pokemon.hp == 30
            else
                menu_prompt = Interactivity.mayIhelpYou?
            end
        end
        choice = prompt.select(menu_prompt, choices) 
        if choice == "My Pokemon isn't feeling well." || choice == "Yes, please! * Hang in there buddy! *"
            Interactivity.pokemon_center_option_treatment(user)
            pokemon_center(true)
        elsif choice == "It's fine. I changed my mind." || choice == "Thank you!"
            main_menu
        elsif choice == "Hey, do I know you?"
            Interactivity.pokemon_center_option_talking(user.name)
            pokemon_center(false, 1)
            self.keep_exploring?
        elsif choice == "Manage inventory"
            puts "MANAGE INVENTORY"
        end
        same_visit = 0
    end
end