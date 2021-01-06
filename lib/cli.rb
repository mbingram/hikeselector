require 'tty-prompt'
ActiveRecord::Base.logger = nil

class Cli
    
    def prompt
        prompt = TTY::Prompt.new
    end

    def welcome
        clear
        puts "Welcome to HikeSelector!"
        name = prompt.ask("What is your name?")
        puts "Hi #{name}!"
    end

    def invitation
        choices = ["Location", "Dog Friendly?", "Elevation Gain", "Difficulty", "Distance"]
        answer = prompt.select("How would you like to search for a hike?", choices)
        hikes = filter_hikes(answer)
        see_hike_details(hikes)
        continue_or_exit
    end

    def continue_or_exit
        choices = ["Look for another hike", "Exit"]
        answer = prompt.select("Would you like to look for another hike or exit?", choices)
        if answer == "Exit"
            exit
        else
            clear
            invitation
        end
    end

    def see_hike_details(hikes)
        hike = prompt.select("Select a hike to view more details:", hikes.pluck(:name))
        hike = Hike.find_by(name: hike)
        puts "NAME: #{hike.name}\nLOCATION: #{hike.location}\nDOG FRIENDLY?: #{hike.dog_friendly}\nDISTANCE: #{hike.distance}\nELEVATION GAIN: #{hike.elevation}\nDIFFICULTY: #{hike.difficulty}"
    end

    def list_hikes
        puts Hike.all.pluck(:name)
    end

    def filter_hikes(filter)
        case filter
        when "Elevation Gain"
            choices = [750, 1000, 1500, 2000, 2500, 3000]
            gain = prompt.select("How much elevation gain is too much elevation gain (in feet)?", choices)
            Hike.elevation(gain)
        when "Distance"
            choices = [4, 5, 6, 7, 8]
            miles = prompt.select("How far is too far (in miles)?", choices)
            Hike.distance(miles)
        when "Difficulty"
            choices = ["Beginner", "Intermediate", "Advanced"]
            selection = prompt.select("How hard do you want it?", choices)
            Hike.difficulty(selection)
        when "Dog Friendly?"
            Hike.dog_friendly?
        when "Location"
            choices = Hike.unique_locations
            location = prompt.select("Where do you want it?", choices, filter: true) 
            Hike.location(location)
        end
    end

    def clear
        system 'clear'
    end

end