# frozen_string_literal: true

require 'pry-byebug'

class Board
  attr_accessor :rank, :file, :coordinates

  def initialize
    @rank = (1..8).to_a
    @file = ('a'..'h').to_a
    @coordinates = []
    assign_positions
  end

  def assign_positions
    @coordinates = rank.product(file).each(&:reverse!).each_slice(8).to_a				
  end
end

class Knight
	attr_accessor :start_coor, :end_coor, :possible_moves, :moves_made	
  
	KNIGHT_MOVES = [[2, 1], [2, -1], [1, 2], [1, -2], [-2, 1], [-2, -1], [-1, 2], [-1, -2]].freeze	

	def initialize
		board = Board.new
		@chess_grid = board.coordinates
		@file_array = board.file		 
		@possible_moves = []
		@moves_made = []
		@move_count = 2					
	end	

	def knight_coors(start_pos, end_pos)		
		@start_coor = [@file_array.index(start_pos[0]), start_pos[1] - 1]
		@end_coor = [@file_array.index(end_pos[0]), end_pos[1] - 1]
		possible_moves(start_coor)				
	end

	def possible_moves(start_coor)		
		@possible_moves.push(start_coor)				
		until @possible_moves.empty?			
			if @moves_made.size > 0
				@possible_moves.delete_if{|coors|coors.flatten.empty?}
				@start_coor = @possible_moves[0].shift			
			else @start_coor = @possible_moves.shift
			end
			moves = KNIGHT_MOVES.map do |coors|			 
				coors.map.with_index{|coor, i| coor + @start_coor[i].to_i}
			end
			@possible_moves.push(moves)
			@moves_made.push(@start_coor)			
		  end_coor_reached									  								
		end		
	end
	
	def end_coor_reached
		if @moves_made.size >= 2 && (@moves_made.size - 1) % 8 == 0			
			@move_count += 1
		end
		if @possible_moves.flatten(1).include?(@end_coor)
			puts "You made it to #{@end_coor} in #{@move_count} moves!"
			p @moves_made
			p @possible_moves
			binding.pry			
			exit						
		end
	end
end

knight = Knight.new
knight.knight_coors(["d", 4], ["h", 5])
