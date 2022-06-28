require 'pry-byebug'

class Board
	attr_accessor :rank, :file, :positions
	
	def initialize
		@rank = (1..8).to_a
	  @file = ("a".."h").to_a		
		@positions = []
		assign_positions
	end

	def assign_positions
		@positions = rank.product(file)
		@positions.each do |position|
			position.reverse!
		end		
	end		
end

class Knight
	KNIGHT_MOVES = [[2,1],[2,-1],[1,2],[1,-2],[-2,1],[-2,-1],[-1,2],[-1,-2]]
end

board = Board.new
p board.assign_positions



