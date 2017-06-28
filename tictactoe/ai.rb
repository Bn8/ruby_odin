
require_relative 'board'

class Ai
	attr_reader :sym

	def initialize(board, sym)
		@board = board
		@sym = sym
	end
	
	def make_move(last_player_move)
		valid_moves = @board.valid_moves
		if valid_moves.size == 0
			return nil
		else
			random_move_index = valid_moves[rand(valid_moves.size)]
			@board.set_cell(random_move_index, @sym)
			return random_move_index
		end
	end
	
end