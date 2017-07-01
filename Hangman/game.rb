
def clearscreen
	system "clear" or system "cls"
end

#============================================================================#

class Words
	attr_reader :arr

	def initialize(fpath)
		load_words fpath
		abbreviate		
	end
		
	def load_words fpath
		@arr = []
		File.foreach(fpath) { |word| @arr.push word.chomp }
	end

	def abbreviate min=5, max=12
		# removing all words that are too short or too long
		@arr.delete_if { |word| (word.size < min or word.size > max) }
	end

	def get_rand
		return @arr[rand(@arr.size)]
	end
end

# generally i'd want to make a whole "GUI" class that will also generate the numerics and printing to terminal I curb myself from making this project thusand lines
class GameOptions
	attr_reader :display_conditions
	def initialize(display_conditions=nil)
		@display_conditions = display_conditions
	end

	def is_showing game_status
		return display_conditions == nil || display_conditions.include?(game_status)
	end
end

class Game
	@@options = {
		:exit => 		GameOptions.new,
		:new => 		GameOptions.new,
		:save => 		GameOptions.new([:in_progress]),
		:load => 		GameOptions.new([:before_start])
		#:guess =>		GameOptions.new([:in_progress], "A to Z", Proc.new { |char| char.match(/^[[:alpha:]]$/) })

	}

	def initialize(fpath = "5desk.txt")
		@words = Words.new fpath
		@exit_game = false
	end

	def show_title name="Hangman"
		puts
		puts " === Welcome to #{name} by Bn8 (c)(tm)(1999-2999) === "
		puts
	end

	def menu
		puts " ***************************"
		puts "* Input options: "
		cur_index = 0
		options_methods = {}
		# populate options_methods and print menu to screen on the way
		@@options.each do |key, value| 
			next unless value.is_showing(@game_status)
			select_option = cur_index
			cur_index += 1 # couldv been a one liner if ruby had ++
			puts "* #{select_option} - #{key} game"
			options_methods[select_option.to_s] = "game_" + key.to_s  # ex: game_save, game_new , ... now wait for it ....... 
		end
		# options for letters (i know, i know, not the most modular approach)
		if @game_status == :in_progress
			select_option = "A to Z"
			puts "* #{select_option} - Guess a letter"
			('a'..'z').each do |letter|
				options_methods[letter] = "game_letter_guess"
			end
		end
		puts " ***************************"

		if @game_status == :in_progress
			puts "Remaining guesses: #{@guesses_left}"
			puts "Wrong letteres guessed so far: #{@letters_wrong.join(',')}"
			show_hangman
		end

		# now hanlde user input
		puts "Enter your choice: "
		inp = gets.chomp.downcase
		while false == options_methods.include?(inp)
			if @game_status == :in_progress
				game_word_guess inp
				return
			end 
			puts "ERROR: Wrong input please try again."
			inp = gets.chomp.downcase
		end

		send(options_methods[inp], inp) # ....... so beautiful ! 

	end


	def engine
		@game_status = :before_start
		show_title
		while not @exit_game
			menu

		end
	end

#========== callbacks ================#
	def game_new _inp
		@game_status = :in_progress
		@word_goal = @words.get_rand
		@word_guess = ["_"]*@word_goal.size
		@letters_right = []
		@letters_wrong = []
		@guesses_left = 12

	end

	def game_word_guess word
		if @word_goal == word
			puts "You win!!"
			@game_status = :before_start
		else
			puts "Wrong word guess"
			update_gusses
		end
	end

	def game_letter_guess letter
		found = ( fill_hangman letter ).size > 0
		puts "You guessed '#{letter}', which #{found ? 'is' : 'isnt'} in the word."
		if !found && !@letters_wrong.include?(letter)
			@letters_wrong.push letter
		end
		show_hangman
		update_gusses
	end

	def game_load _inp
	end

	def game_save _inp
	end

	def game_exit _inp
		@exit_game = true
	end

#========== hangman ==================#

	def update_gusses
		@guesses_left -= 1
		if @guesses_left == 0
			puts "You lose, no more guesses left."
			puts "The word was '#{@word_goal}'."
			@game_status = :before_start
		end
	end

	def fill_hangman letter
		find_indices(letter).each do |i|
			@word_guess[i] = letter
		end
	end

	def show_hangman
		puts @word_guess.join(' ')
	end

	def find_indices letter_to_find
		indices = []
		@word_goal.each_char.with_index do |letter, index|
			indices.push(index) if letter == letter_to_find
		end
		return indices
	end

end

game = Game.new.engine
