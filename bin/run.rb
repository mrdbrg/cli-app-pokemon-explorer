require_relative '../config/environment'

interface = Interface.new()
interface.greet
current_trainer = interface.choose_new_trainer_or_check_inventory 
interface.user = current_trainer[:trainer]

current_trainer[:isItNew] == true ? interface.welcome(true) : interface.welcome(false)
