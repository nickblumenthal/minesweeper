require './tile.rb'

class Board
  attr_reader :mines, :mine_coords, :tiles
  attr_accessor :unrevealed, :bombed

  def initialize
    @mines = 5
    @unrevealed = 81
    @mine_coords = []
    @tiles = Array.new(9){ Array.new(9) }
    @bombed = false
    generate_mine_coords
    generate_tiles
    generate_mines
  end

  def generate_mine_coords
    until mine_coords.length == mines
      row = (0...tiles.length).to_a.sample
      col = (0...tiles.length).to_a.sample
      mine_coords << [row, col] unless mine_coords.include?([row, col])
    end

    mine_coords
  end

  def generate_mines
    mine_coords.each do |coord|
      row, col = coord
      self.tiles[row][col].bombed = true
    end
  end

  def generate_tiles
    tiles.length.times do |row|
      tiles.length.times do |col|
        self.tiles[row][col] = Tile.new(self, [row,col])
      end
    end
  end

  def show_bombs
    mine_coords.each do |coords|
      row, col = coords
      tiles[row][col].update_symbol(:bombed)
    end
  end
end
