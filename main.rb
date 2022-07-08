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
    @visited_squares = []
  end

  def knight_moves(start_pos, end_pos)
    @start_coor = [@file_array.index(start_pos[0]), start_pos[1] - 1]
    @end_coor = [@file_array.index(end_pos[0]), end_pos[1] - 1]
    possible_moves(start_coor)
  end

  def possible_moves(start_coor)
    @possible_moves.push(start_coor)
    while @possible_moves.any?
      if @visited_squares.size.positive?
        @possible_moves.delete_if { |coors| coors.flatten.empty? }
        @start_coor = @possible_moves[0].shift
        next if @visited_squares.include?(@start_coor)
      else
        @start_coor = @possible_moves.shift
      end
      @moves = KNIGHT_MOVES.map do |coors|
        coors.map.with_index { |coor, i| coor + @start_coor[i].to_i }
      end
      @visited_squares.push(@start_coor)
      check_edges(@moves)
      @possible_moves.push(@moves)
      end_coor_reached
    end
  end

  def check_edges(_moves)
    @moves.keep_if do |coors|
      coors[0].between?(0, 7) && coors[1].between?(0, 7)
    end
  end

  def build_path
    @path = [@end_coor]
    @path << @visited_squares.last
    until @path.last == @visited_squares[0]
      @next_index = @visited_squares.size - @possible_moves.size
      @path << @visited_squares[@next_index] unless @next_index < 2
      if @next_index == 2 || @next_index.zero?
        @path << @visited_squares[0]
      elsif @next_index == 32 && @end_coor[0] == @end_coor[1]
        @path << @visited_squares[(@next_index / 2) - 2]
        @path << @visited_squares[(@next_index / 8) + 1]
        @path << @visited_squares[1]
      elsif @next_index == 32 && @end_coor[0] != @end_coor[1]
        @path << @visited_squares[(@next_index / 2) + 1]
        @path << @visited_squares[(@next_index / 8) + 1]
        @path << @visited_squares[1]
      elsif @next_index == 34 && @end_coor[0] == @end_coor[1]
        @path << @visited_squares[(@next_index / 2)]
        @path << @visited_squares[(@next_index / 8)]
        @path << @visited_squares[1]
      elsif @next_index == 34 && @end_coor[0] != @end_coor[1]
        @path << @visited_squares[(@next_index / 2) + 1]
        @path << @visited_squares[(@next_index / 8)]
        @path << @visited_squares[1]
      elsif @next_index >= 15 && @possible_moves.size.odd?
        @path << @visited_squares[(@next_index / 4)]
        @path << @visited_squares[1]
      elsif @next_index >= 15 && @possible_moves.size.even?
        @path << @visited_squares[(@next_index / 4) + 1]
        @path << @visited_squares[1]
      elsif @possible_moves.size.odd? && @next_index.even?
        @path << @visited_squares[2]
      elsif @possible_moves.size.odd? && @next_index.odd?
        @path << @visited_squares[1]
      elsif @possible_moves.size.even? && @next_index.even?
        @path << @visited_squares[2]
      elsif @possible_moves.size.even? && @next_index.odd?
        @path << @visited_squares[1]
      end
      @path << @visited_squares[0]
    end
  end

  def end_coor_reached
    if @possible_moves.flatten(1).include?(@end_coor)
      build_path
      puts "You made it in #{@path.size - 1} moves! Here's your path:"
      @path.reverse!
      @path.each { |move| p move }
      p @visited_squares
      binding.pry
      exit
    end
  end
end

knight = Knight.new
knight.knight_moves(['a', 1], ['h', 8])
