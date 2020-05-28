class Interactivity

  @@legendary = ["Moltres", "Zaptos", "Articuno"]
  @@walking_in_town = ["Walking in town", "is that a pokemon?", "No Pokemons here...", "grrr... I'm hungry! ", "WoW... was that an Articuno?!", "Oh no, it's that Gary guy!"]
  @@walking_in_town_response = ["or here...", "Nope!"]

  def self.welcome_to_town(user)
    puts "==================================================="
    puts ""
    puts "Welcome to #{user.town_name}!"
    puts ""
    puts "===================================================" 
  end

  def self.found_pokemon(pokemon)
    puts "==================================================="
    puts ""
    puts "YOU FOUND #{pokemon.name.upcase}!"
    puts ""
    puts "==================================================="
  end

  # Why does .timing have to be a class method and not simply a instance method ???
  def self.timing
    sleep(0.5)
    print "."
    sleep(0.5)
    print "."
    sleep(0.5)
    print "."
    sleep(0.5)
    print "."
    print "\n"
  end

  def self.walking_in_town
    legends = []
    rand(2..4).times do 
    phrase = @@walking_in_town.sample

    puts phrase if !legends.find {|legend| phrase[legend] }

    if phrase[0, 3] == "WoW"
      legends.find { |legend| phrase[legend] } ? inIt = false : inIt = true
    if inIt
      legends.push(@@legendary.find { |leg| phrase[leg] })
    end
    elsif phrase == "No Pokemons here..."
      timing
      puts @@walking_in_town_response[0]
    elsif phrase == "is that a pokemon?"
      timing
      puts @@walking_in_town_response[1]
    end
      timing
    end
  end   

end