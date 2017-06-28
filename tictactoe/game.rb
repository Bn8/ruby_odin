
require_relative 'board'
require_relative 'helpers'
require_relative 'ai'

class Game
	@@options = {
		:exit => ['q','Q'], 
		:new_game => ['n','N'],
		:moves => (1..9).to_a
	}


	def initialize(args=nil)
		new_game
	end
	
	def new_game
		@board = Board.new
		@error_message = nil
		@winner = nil
		@tie = false
		@player_move = nil
		@player_symbol = Board.symbols[0]
		@ai = Ai.new(@board, Board.symbols[1])
		#@turn = rand(2)
	end

	def show_title
		puts
		puts " === Welcome to TicTacToe by Bn8 (c)(tm)(1999-2999) === "
		puts
	end

	def show_menu_pregame
		puts " Input options: "
		puts " Q - quit game "
		puts !is_game_end ? " 1..9 - play on that cell" : " N - new game "
	end

	def show_error_message
		puts @error_message ? ">ERROR: " + @error_message : ""
		@error_message = nil
	end

	def show_winner_message
		puts "'#{@winner}' has won !!!" if @winner
		puts "Its a tie !" if @tie
	end


	def is_game_end
		return (nil != @winner or true == @tie)
	end

	# control the game by the user input given (exit, new game, make move..)
	def handle_user_input(input)
		@player_move = nil

		if @@options[:exit].include? input
			puts "Terminating game.."
			@exit_game = true

		elsif @@options[:new_game].include? input
			new_game

		elsif @@options[:moves].include? input.to_i and !is_game_end
			int_input = input.to_i
			if @board.is_open(int_input)
				@board.set_cell(int_input, @player_symbol)
				@player_move = true
			else
				@error_message = "You cannot move to <#{int_input}>, choose again."
			end

		else
			@error_message = "Invalid input '#{input}'"

		end

	end

	# check end game for given symbol player and assign @winner if so
	def handle_win(sym)	
		if @board.is_winner(sym)
			@winner = sym
		end
	end

	def handle_end_turn(input)
		# check if player made a valid move, then make the AI move and handle win/tie variables
		if !is_game_end and @player_move != nil
			if @board.valid_moves.size == 0
				@tie = true
				return # we couldv skipped it
			end

			handle_win(@player_symbol) 
			if !is_game_end
				@tie = true if (nil == @ai.make_move(input.to_i)) # AI couldnt move, no legal moves means a tie
				handle_win(@ai.sym) # otherwise check for AI win (we can still check if its a tie it doesnt matter)
			end
		end
	end

	def engine
		@exit_game = false
		while not @exit_game

			clearscreen

			show_title

			show_error_message

			show_winner_message

			puts

			show_menu_pregame

			puts

			@board.print

			@player_move = nil

			input = gets.chomp

			handle_user_input(input)

			handle_end_turn(input)

		end
	end
	
end



clearscreen

Game.new.engine