class Interface 
    attr_accessor :prompt, :user, :user_current_location
    @@trainer_pepTalk = ["Go catch them all!", "It's great to see you again."]
    @@newbie_pepTalk = ["I hope you know what you're doing.", "Are you still there? ...chop chop... the time is ticking!", "Don't waste your time. You got work to do."]
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
        menu_options = ["Start exploring", "Check Inventory", "Check Your Score", "Quit"]
        menu_prompt = "What would you like to do?"

        menu_options.push("Go to Pokemon Center") if user.pokemon.hp < 30
        
        if self.user_current_location
            menu_options.shift()
            menu_options.unshift("Keep Exploring")
        elsif user.pokemon == nil
            menu_options.shift()
            menu_options.unshift("Choose a Pokemon and start exploring")
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
        end
    end 

    # ===========================================================================================
    # ====                                CHOOSE POKEMON                                     ====
    # ===========================================================================================

    def trainer_chooses_pokemon
        choose_pokemon =  {"Fire" => "Charmander", "Grass" => "Bulbasaur", "Water" => "Squirtle"}
        type_choice = prompt.select("Time to choose ", choose_pokemon.keys) 
        user.pokemon = Pokemon.find_by(name: choose_pokemon[type_choice])
        user.save
    end

    # ===========================================================================================
    # ====                                  CHOOSE TOWN                                      ====
    # ===========================================================================================

    def trainer_chooses_town
        town_choices = Location.where.not(town_name: "Pallet Town").map {|town| town.town_name}
        menu_prompt = "Which town would you like to explore?"
    
        choice = prompt.select(menu_prompt, town_choices) 
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
        menu_prompt = "Would you like to keep exploring?"
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
        choice = prompt.select("Would you like to fight #{@@wild_pokemon.name}?", ["Let's BATTLE!", "No, I don't wanna battle."]) 
        if choice == "Let's BATTLE!"
            self.accepts_battle
        elsif choice == "No, I don't wanna battle."
            self.keep_exploring?  
        end 
    end 

    def accepts_battle
        win_or_lose = ["You got this!", "That one looks tough", "Don't make it angry", "Time to train!"]
        user_pokemon = self.user.pokemon

        while user_pokemon.hp > 0 && @@wild_pokemon.hp > 0
          if user_pokemon.attack > @@wild_pokemon.attack
            puts win_or_lose.sample
            self.battling(@@wild_pokemon, user_pokemon)
          else
            puts win_or_lose.sample
            self.battling(user_pokemon, @@wild_pokemon)
          end
        end
    end 
  
    def battling(losing_side, upperhand)
        weak_defense = ["Nice, dodge!!", "Easy Peasy", "This is your chance... COUNTER ATTACK!", "Wait for the right moment... now!", "Ha! That tickled"]
        strong_defense = [ "Great reflexes!!", "That one is tough, but we can handle it.", "Counter attack!! Counter attack!!", "Don't give up!", "You got hit really hard.", "Be careful!"]

        while losing_side.hp > 0 && upperhand.hp > 0
            sleep 1
            if upperhand.defense > losing_side.defense
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
        if losing_side.hp == 0
            puts "***************************************************"
            puts "***************************************************"
            puts "***************************************************"
            puts "              #{upperhand.name} WON!"
            puts "Your HP: #{user.pokemon.hp}"
            poke = Pokemon.all.find_by(name: user.pokemon.name)
            puts "Your HP FROM DATABASE: #{poke.hp}"
            puts "***************************************************"
            puts "***************************************************"
            puts "***************************************************"
            # Battle.create(pokemon_id: losing_side.id, trainer_id: user.id)
            self.keep_exploring?
            # binding.pry
        end 
    end

    def go_to_pokemon_center?
        puts "============================================"
        puts "=====  You lost this battle. Sorry!  ======="
        puts "============================================"
        choices = ["Yes, take me to the nearest Pokemon Center!", "No, let's just go home"]
        menu_prompt = "Your Pokemon needs medical assistance. Would you like to go to the nearest Pokemon Center?"
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
            menu_prompt = "How else may I help you?"
        else
            puts "============================================"
            puts "=====  WELCOME TO THE POKEMON CENTER  ======"
            puts "============================================"
            choices = ["My Pokemon isn't feeling well.", "Manage inventory", "It's fine. I changed my mind.", "Hey, do I know you?"]
            menu_prompt = "Hi, my name is Joy! May I help you?"
            if user.pokemon.hp == 0
                choices.shift()
                choices.unshift("Yes, please! * Hang in there buddy! *")
                choices.pop(3)
                menu_prompt = "Hurry! Let's take your #{user.pokemon.name} to the emergency room!"
            elsif same_visit == 1
                menu_prompt = "Now, how may I help you #{user.name}?"
                choices = ["I think I'm all set. Thank you!", "Manage inventory", "My Pokemon isn't feeling well."]
            end
        end
        choice = prompt.select(menu_prompt, choices) 
        if choice == "My Pokemon isn't feeling well." || choice == "Yes, please! * Hang in there buddy! *"
            pokemon_center_option_treatment
        elsif choice == "It's fine. I changed my mind." || choice == "Thank you!"
            main_menu
        elsif choice == "Hey, do I know you?"
            pokemon_center_option_talking
            pokemon_center(nil, 1)
            self.keep_exploring?
        elsif choice == "Manage inventory"

        end
        same_visit = 0
    end

    def pokemon_center_option_treatment
        hp_recover = 30 - user.pokemon.hp
        user.pokemon.hp += hp_recover

        puts "We're treating your Pokemon!"
        3.times do 
            Interactivity.timing(true)
        end
        puts "You're all set! Your #{user.pokemon.name} is feeling like new."
        self.pokemon_center(true)
    end

    def pokemon_center_option_talking
        puts "DO I KNOW YOU!"
        puts "* Nurse Joy smiles * No, you must've met my sister. We're twins!"
        sleep 2
        puts "What's your name?"
        sleep 2
        puts "My name is #{user.name}. Nice to meet you!"
        sleep 2
    end
end


# puts "#{@@wild_pokemon.name}"
# puts "Attack: #{@@wild_pokemon.attack}"
# puts "defense: #{@@wild_pokemon.defense}"
# puts "HP: #{@@wild_pokemon.hp}"
# puts "===================="
# puts "#{user.pokemon.name}"
# puts "Attack: #{user.pokemon.attack}"
# puts "defense: #{user.pokemon.defense}"
# puts "HP: #{user.pokemon.hp}"

# puts "#{upperhand.name} WON!"
# puts "Your HP: #{user.pokemon.hp}"
# user_poke = Pokemon.all.find_by(name: user.pokemon.name)
# puts "Your POKEMON NAME FROM DATABASE: #{user_poke.name}"
# puts "Your HP FROM DATABASE: #{user_poke.hp}"
# puts "Wild pokemon NAME: #{lowerhand.name}"
# puts "Wild pokemon: #{lowerhand.hp}"
# poke = Pokemon.all.find_by(name: lowerhand.name)
# puts "Wild pokemon NAME FROM DATABASE: #{poke.name}"
# puts "Wild pokemon NAME FROM DATABASE: #{poke.hp}"
# # user.pokemon.update()