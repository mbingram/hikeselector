require 'tty-prompt'
ActiveRecord::Base.logger = nil

class Cli
    
    def prompt
        prompt = TTY::Prompt.new
    end

    def welcome
        clear
        puts "Welcome to HikeSelector!"
        login
    end

    def login
        username = prompt.ask("What is your username?")
        puts "Hi #{username}!"
        password = prompt.ask("What is your password?")
        @user = User.check_if_exist(username)
        if @user
            if @user.validate_password(password)
                find_or_favorite
            else
                puts "Oops! Wrong password."
                login
            end
        else
            puts "User not found, would you like to create an account?"
            @user = new_user
            find_or_favorite
        end 
    end

    def new_user
        username = prompt.ask("What is your username?")
        password = prompt.ask("What is your password?")
        User.create username: username, password_string: password
    end

    def find_or_favorite
        choices = ["Look for a hike.", "View favorites."]
        answer = prompt.select("Would you like to look for a hike, or view favorites?", choices)
        if answer == "Look for a hike."
            invitation
        else
            puts @user.favorite_hikes
        end

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
        add_to_favorites(hike)
    end

    def add_to_favorites hike
        answer = prompt.yes?("Would you like to add this hike to your favorites?")
        if answer
            Userhike.create(user_id: @user.id, hike_id: hike.id)
            puts "You have added a favorite!"
        else 
            continue_or_exit
        end        
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