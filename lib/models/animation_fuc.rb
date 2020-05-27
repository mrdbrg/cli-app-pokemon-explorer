  def animation
    10.times do #however many times you want it to go for
        i = 1
        while i < 14 #20 gif instances starting from 0
        # print "\033[2J" 
                #the folder path     #the iterating file 
        File.foreach("lib/animations/pikachu_explorer/#{i}.rb") { |f| puts f }
        sleep(0.10) #how long it is displayed for
        i += 1
        end
    end
  end