
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
		puts @winner == nil ? " 1..9 - play on that cell" : " N - new game "
	end

	def show_error_message
		puts @error_message ? ">ERROR: " + @error_message : ""
		@error_message = nil
	end

	def show_winner_message
		puts "'#{@winner}' has won !!!" if @winner
		puts "Its a tie !" if @tie
	end

	# control the game by the user input given (exit, new game, make move..)
	def handle_user_input(input)
		@player_move = nil

		if @@options[:exit].include? input
			puts "Terminating game.."
			@exit_game = true

		elsif @@options[:new_game].include? input
			new_game

		elsif @@options[:moves].include? input.to_i and @winner == nil and @tie == false
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

	def is_win(sym)
		# check end game
		if @board.is_winner(sym)
			@winner = sym
			return true
		end
		return false
	end

	def engine
		@exit_game = false
		while not @exit_game

			#clearscreen

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

			# check if player made a valid move
			if @winner == nil and @tie == false and @player_move != nil
				if @board.valid_moves.size == 0
					@tie = true
				elsif !is_win(@player_symbol)
					ai_move = @ai.make_move(input.to_i)
					if ai_move == nil
						@tie = true
					elsif is_win(@ai.sym)
						@winner = @ai.sym
					end
				end
			end

		end
	end
	
end



clearscreen

Game.new.engine