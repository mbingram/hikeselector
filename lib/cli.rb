require 'tty-prompt'
ActiveRecord::Base.logger = nil

class Cli
    
    def prompt
        prompt = TTY::Prompt.new
    end

    def welcome
        puts "Welcome to HikeSelector!"
        name = prompt.ask("What is your name?")
        puts "Hi #{name}!"
    end

    def invitation
        choices = ["Location", "Dog Friendly?", "Elevation Gain", "Difficulty", "Distance"]
        answer = prompt.select("How would you like to search for a hike?", choices)
        filter_hikes(answer)
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
        when "Dog Friendly"
            Hike.dog_friendly?
        when "Location"
            choices = Hike.unique_locations
            location = prompt.select("Where do you want it?", choices)
            Hike.location(location)
        end
    end

end