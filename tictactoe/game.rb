
require_relative 'board'
require_relative 'helpers'


game_screen = \
"Chose input (..)

remember ...

"

class Game
	@@players = {:player1 => "Player 1", :player2 => "Player 2"}
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
	end

	def engine
		exit_game = false
		while not exit_game
			player_symbol = Board.symbols[0]

			clearscreen

			show_title

			show_error_message

			show_winner_message

			puts

			show_menu_pregame

			puts

			@board.print

			player_move = nil

			input = gets.chomp

			if @@options[:exit].include? input
				puts "Terminating game.."
				exit_game = true

			elsif @@options[:new_game].include? input
				new_game

			elsif @@options[:moves].include? input.to_i and @winner == nil
				int_input = input.to_i
				if @board.is_open(int_input)
					@board.set_cell(int_input, player_symbol)
					player_move = true
				else
					@error_message = "You cannot move to <#{int_input}>, choose again."
				end

			else
				@error_message = "Invalid input '#{input}'"

			end

			# check if player made a valid move
			if player_move != nil
				# check end game
				if @board.is_winner(player_symbol)
					@winner = player_symbol
				end
				# ai makes a move
			end

		end
	end
	
end



clearscreen

Game.new.engine