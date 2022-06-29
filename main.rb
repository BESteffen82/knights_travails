# frozen_string_literal: true

require 'pry-byebug'

class Board
  attr_accessor :rank, :file, :positions

  def initialize
    @rank = (1..8).to_a
    @file = ('a'..'h').to_a
    @positions = []
    assign_positions
  end

  def assign_positions
    @positions = rank.product(file).each(&:reverse!).each_slice(8).to_a.reverse!
		@chess_grid = @positions.each{|x| x}    
  end
end

class Knight
  KNIGHT_MOVES = [[2, 1], [2, -1], [1, 2], [1, -2], [-2, 1], [-2, -1], [-1, 2], [-1, -2]].freeze

	def knight_moves(start_position, end_position)
		
end

board = Board.new
board.assign_positions
