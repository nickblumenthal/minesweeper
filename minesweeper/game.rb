require './board.rb'
require './tile.rb'
require 'yaml'
require 'io/console'
require 'colorize'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def run
    render
    until won? || lost?
      x, y, choice = get_user_input
      update_board(x, y, choice)
      render_cursor([x,y])
    end

    if lost?
      system('clear')
      puts "You lost!"
      board.show_bombs
      render
    else
      system('clear')
      render
      puts "You won!"
    end
  end

  def kb_user_input(current_pos = [0,0])
    system('clear')
    render_cursor(current_pos)
    input = STDIN.getch

    unless input == "\r"
      system('clear')
      case input
      when 'w'
        current_pos[0] -= 1 if current_pos[0].between?(1,8)
      when 'a'
        current_pos[1] -= 1 if current_pos[1].between?(1,8)
      when 's'
        current_pos[0] += 1 if current_pos[0].between?(0,7)
      when 'd'
        current_pos[1] += 1 if current_pos[1].between?(0,7)
      end

      kb_user_input(current_pos)
    end

    system('clear')
    current_pos
  end

  def get_user_input
    puts "Flag, reveal, or save? (f, r, s)"
    choice = gets.chomp
    if choice == 's'
      save
    end

    coords = kb_user_input
    x, y = coords

    if board.tiles[x][y].revealed?
      puts "Already revealed!"
      get_user_input
    end

    coords << choice
  end

  # def get_user_input
  #   puts "Flag, reveal, or save? (f, r, s)"
  #   choice = gets.chomp
  #   if choice == 's'
  #     save
  #   end
  #
  #   puts "Choose coordinates: (row column)"
  #   coords = gets.chomp.split.map(&:to_i)
  #   x, y = coords
  #   if board.tiles[x][y].revealed?
  #     puts "Already revealed!"
  #     get_user_input
  #   end
  #
  #   coords << choice
  # end

  def update_board(row, col, choice)
    if choice == 'f'
      board.tiles[row][col].toggle_flag
    else
      board.tiles[row][col].reveal
    end
  end

  def render_cursor(coords)
    board.tiles.length.times do |row|
      board.tiles.length.times do |col|
        if row == coords[0] && col == coords[1]
          print "@ ".colorize(:red)
        else
          print "#{board.tiles[row][col].render_symbol} "
        end
      end
      print "\n"
    end

    nil
  end

  def render
    board.tiles.length.times do |row|
      board.tiles.length.times do |col|
        print "#{board.tiles[row][col].render_symbol} "
      end
      print "\n"
    end

    nil
  end

  def won?
    pos_mines = 0
    board.tiles.length.times do |row|
      board.tiles.length.times do |col|
        pos_mines += 1 if board.tiles[row][col].render_symbol == '*'
      end
    end

    pos_mines == board.mines
  end

  def lost?
    board.bombed
  end

  def save
    puts "Filename:"
    filename = gets.chomp
    saved_game = self.to_yaml
    File.open("#{filename}.yml", 'w') { |f| f.puts saved_game }
  end

  def self.load
    puts "Filename:"
    filename = gets.chomp
    loaded_game = File.read("#{filename}.yml")
    game = YAML::load(loaded_game)
    game.run
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Do you want to load a game? (y/n)"
  input = gets.chomp.downcase
  if input == 'y'
    Game.load
  else
    game = Game.new
    game.run
  end
end
