trainer_poke => #USER'S POKEMON
Attack = 10
Defense = 15
HP = 30

wild_pokemon
Attack = 15
Defense = 10
HP = 7

def keep_attacking(trainer_poke, wild_pokemon)
    while trainer_poke.HP != 0 || wild_pokemon.HP != 0

        if trainer_poke.attack > wild_pokemon.attack
            puts "You got the upper hand!"

            self.battling(wild_pokemon, trainer_poke)

        else
            puts "This is gonna be tough!"

            self.battling(trainer_poke, wild_pokemon)
        end
    end
end

def battling(lowerhand, upperhand)
    if upperhand.defense > lowerhand.defense
        puts "You're pokemon got this! It's gonna be easy!"
        IF upperhand.HP > 10 do this => upperhand.HP take 10 point from HP 
            IF NOT upperhand.HP = 0 ALSO take 2 points from lowerhand.HP
    else
        puts "They're strong! But they dont stand a chance!"
        IF upperhand.HP > 5 do this => upperhand.HP take 5 points from HP => now we have 2 pts left of HP
            IF NOT upperhand.HP = 0 take 4 points from lowerhand.HP
    end
end

trainer_pokemon HP = 30 

HP = 12 => 


HP = 30 

def pokemon_center
    # HI WELCOME TO POKEMON CENTER
    sleep 5
    # ... we're taking care of your pokemon
    sleep 3
    # ALL SET. YOU'RE POKEMON IS GOOD TO GO! GOOD BYE!
    trainer.pokemon.HP = 30
end

def battle_exp
    # score WIN/LOSES
    if WIN > 8
        HP = 40
    end
    HP
end