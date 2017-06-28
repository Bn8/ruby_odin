
#--------------------------------------------------------------------------------------

class Cell
	attr_reader :index
	attr_accessor :val

	def initialize(cell_index)
		@index = cell_index
		@val = cell_index
	end

	def to_s
		return " #{val} "
	end
	
end

#--------------------------------------------------------------------------------------

class Board
	@@symbols = ['X', 'O']
	def self.symbols; @@symbols; end

	def initialize(args=nil)
		@cells = (1..9).map { |i| Cell.new(i) } # create 9 cells each numbered from 1 to 9
	end


	def set_cell(cell_number, value)
		@cells[cell_number-1].val = value
	end
	
	def is_open(cell_number)
		return ( not @@symbols.include? @cells[cell_number-1].val )
	end

	# return array of numbers-indices (1..9) that considered a win in the @cells array
	def win_arrays
		winarrs = [
			[1,2,3],[4,5,6],[7,8,9],
			[1,4,7],[2,5,8],[3,6,9],
			[1,5,9],[3,5,7]
		]

		return winarrs
	end

	# return true if given symbol is winning the board
	def is_winner(symb)
		win_arrays.each do |win_array|
			res = win_array.all? do |num| 
				symb == @cells[num-1].val
			end
			return true if res == true
		end
		return false
	end

#--------------------------------------------------------------------------------------#
	def print
		puts to_s
	end

	def to_s
		return [(1..3).map { |i| to_s_row(i)} ].join(to_s_row_seperate)
	end

#--------------------------------------------------------------------------------------#
	private

	def to_s_row(row)
		cell_start, cell_end = (row-1)*3, (row-1)*3 + 2
		return @cells[cell_start..cell_end].map { |cell| cell.to_s }.join("|")
	end

	def to_s_row_seperate
		return "\n---+---+---\n"
	end
end
#--------------------------------------------------------------------------------------
