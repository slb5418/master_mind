class MasterMind
    def initialize
        puts "\nThis is the Master Mind!"
        puts "\nThe Computer has four secret colors that you need to guess."
        puts "Each guess, you will input four colors in a specific order."
        puts "Depending on the input, the computer will return key pegs, black or white."
        puts "The computer returns black key pegs for code pegs of the correct color and order."
        puts "The computer returns white key pegs if there are code pegs of the correct color but not order.\n"
        # computer generates the secret colors
        @computer = Computer.new()
        @human = HumanPlayer.new()
        puts "\nLet's Play!"
        puts "Would you like to guess the computer's code or create a code for the computer to guess?"
        puts "\nEnter guess or code:"
        option = gets.chomp().strip()
        if option == "guess" 
            puts "\nVery well! you're guessing"
            self.play_guess()
        elsif option == "code"
            "\nYou're creating a code!" 
            self.play_code()
        end
    end

    def play_guess()
        while @human.numberOfGuesses > 0
            puts "\nEnter your guess!"
            guess = @human.guess()  
            puts "\nGuess: #{guess}"
            feedback = @computer.feedback(guess)
            if feedback == ["black","black","black","black"]
                puts "\nYou Win!"
                puts "Secret Colors: #{@computer.secretColors}\n"
                exit
            end
            puts "Computer Feedback: #{feedback}"
        end
        puts "\nYou did not guess the secret code!"
        puts "Secret Code: #{@computer.secretColors}"
        puts "Better luck next time!\n"
    end

    def play_code()
        @human.create_code()
        while @computer.numberOfGuesses > 0
            puts "Number of Computer Guesses: #{@computer.numberOfGuesses}"
            guess = @computer.secretColors
            puts "Computer's guess: #{guess}"
            
            if guess == @human.secretCode
                puts "\nThe Computer Won!"
                puts "Secret Colors: #{@human.secretCode}\n"
                exit
            end

            feedback = @human.feedback(guess)
            puts "Feedback: #{feedback}"
            @computer.numberOfGuesses -= 1
            @computer.secretColors = @computer.guess(feedback)
        end
        puts "\nThe Computer was not able to guess your code!"
        puts "You win!"
    end


    class Computer

        attr_accessor :secretColors, :numberOfGuesses, :tracker

        def initialize
            @secretColors = generate_secret_colors()
            @numberOfGuesses = 12
            @tracker = []
        end

        def generate_secret_colors()
            colors = ["white", "black", "red", "blue", "yellow", "green"]
            secretColors = []
            4.times do |c|
                c = colors[Random.rand(0..5)]
                secretColors << c
            end
            return secretColors
        end

        def feedback(guess)
            keyPegs = []
            guess.each_with_index do |color, i|
                if @secretColors[i] == color
                    keyPegs << "black"
                elsif @secretColors.include? color and keyPegs.count(color) < @secretColors.count(color)
                    keyPegs << "white"
                else
                    keyPegs << nil
                end
            end
            return keyPegs
        end

        def guess(feedback)
            colors = ["white", "black", "red", "blue", "yellow", "green"]
            guess = []
            white_flag = false
            white_color = nil
            feedback.each_with_index do |color, i|
                if color == "black"
                    guess << @secretColors[i]
                elsif white_flag == true
                    guess << white_color
                    white_flag = false
                elsif color == "white"
                    white_flag = true
                    white_color = @secretColors[i]
                    guess << colors[Random.rand(0..5)]
                else
                    guess << colors[Random.rand(0..5)]
                end
            end
            return guess
        end
    end


    class HumanPlayer

        attr_accessor :numberOfGuesses, :secretCode

        def initialize
            @numberOfGuesses = 12
            @secretCode = []
        end

        def guess()
            puts "Guesses left: #{@numberOfGuesses}"
            puts "Enter four colors from (white, black, red, blue, yellow, green)"
            puts "\nFirst color:"
            firstColor = gets.chomp().strip()
            puts "\nSecond color:"
            secondColor = gets.chomp().strip()
            puts "\nThird color:"
            thirdColor = gets.chomp().strip()
            puts "\nFourth color:"
            fourthColor = gets.chomp().strip()
            @numberOfGuesses -= 1

            guess = [firstColor, secondColor, thirdColor, fourthColor]
        end

        def create_code()
            puts "\nLet's create a secret code!"
            puts "Please enter four colors (white, black, red, blue, yellow, green)"
            puts "\nFirst color:"
            @secretCode << gets.chomp().strip()
            puts "\nSecond color:"
            @secretCode << gets.chomp().strip()
            puts "\nThird color:"
            @secretCode << gets.chomp().strip()
            puts "\nFourth color:"
            @secretCode << gets.chomp().strip()
            puts "\nYour secret code!: #{@secretCode}"
        end

        def feedback(guess)
            keyPegs = []
            guess.each_with_index do |color, i|
                if @secretCode[i] == color
                    keyPegs << "black"
                elsif @secretCode.include? color and keyPegs.count(color) < @secretCode.count(color)
                    keyPegs << "white"
                else
                    keyPegs << nil
                end
            end
            return keyPegs
        end
    end

end


MasterMind.new()