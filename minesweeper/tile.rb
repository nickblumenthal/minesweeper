require './board.rb'
require 'byebug'

class Tile
  NEIGHBORS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  SYMBOLS = {
    :flagged =>'F',
    :revealed => '_',
    :bombed => '!',
    :unrevealed => '*',
    1 => '1',
    2 => '2',
    3 => '3',
    4 => '4',
    5 => '5',
    6 => '6',
    7 => '7',
    8 => '8'
  }

  attr_reader :board, :coords, :flagged
  attr_accessor :render_symbol, :revealed, :bombed

  def initialize(board, coords)
    @board = board
    @coords = coords
    @bombed = false
    @revealed = nil
    @flagged = nil
    @render_symbol = SYMBOLS[:unrevealed]
  end

  def reveal
    # if not bombed, reveal
    unless bombed? || revealed
      if neighbor_bomb_count == 0
        self.revealed = true
        update_symbol(:revealed)
        neighbors.each { |neighbor| neighbor.reveal }
      else
        update_symbol(neighbor_bomb_count)
      end
    end

    if bombed?
      update_symbol(:bombed)
      self.board.bombed = true
    end
  end

  def update_symbol(symbol)
    self.render_symbol = SYMBOLS[symbol]
  end

  def toggle_flag # toggle_flag
    if flagged == nil || flagged == false
      flagged = true
      update_symbol(:flagged)
    else
      flagged = false
      update_symbol(:unrevealed)
    end
  end

  def neighbors
    adjacents = []

    NEIGHBORS.each do |neighbor|
      x, y = neighbor
      row, col = coords
      if (row + x).between?(0, board.tiles.length - 1) &&
        (col + y).between?(0, board.tiles.length - 1)
        adjacents << board.tiles[row + x][col + y]
      end
    end

    # return tile objects
    adjacents
  end

  def neighbor_bomb_count
    bomb_count = 0
    # adjacents = neighbors
    neighbors.each do |neighbor|
      bomb_count += 1 if neighbor.bombed?
    end

    bomb_count
  end

  def revealed?
    revealed
  end

  def bombed?
    @bombed
  end

  def flagged?
    flagged
  end

end
