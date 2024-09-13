# Script to run the hangman gameplay

require_relative 'dictionary'
require_relative 'game'

# This is a method to the get the player's input if they want to continue a previous game 
def get_player_choice(existing_games_file_path, dictionary_file_path)
  puts "\nDo you want to continue a previous game? Y/N"
  choice = gets.chomp
  if choice == 'Y'
    load_previous_game(existing_games_file_path)
  elsif choice == 'N'
    play_new_game(existing_games_file_path, dictionary_file_path)
  else
    get_player_choice
  end
end

# This is a method to load a previous game file from the saved games directory.
# After the file is loaded, a new Game object wil be created and it will be updated with all of the existing data.
def load_previous_game(existing_games_file_path)
  puts "\nPlease continue an existing game by selecting the file path:"
  puts available_files = Dir['lib/saved_games/*']
  file_path = gets.chomp
  if available_files.include?(file_path)
    file = File.open(file_path, 'r')
    game_data = Marshal.load(file.read)
    file.close
    game = Game.new(existing_games_file_path)
    game.load_game(game_data)
    game.print_current_game_information
    game.play_game
  else
    load_previous_game
  end
end

# This is a method to start a new game. 
# The order of operations is create game --> create dictionary --> choose word --> link dictionary/word to game --> play game.
def play_new_game(existing_games_file_path, dictionary_file_path)
  puts 'Starting a new game...'
  game = Game.new(existing_games_file_path)
  dictionary = Dictionary.new(game, dictionary_file_path)
  dictionary.setup_dictionary
  game.setup_game(dictionary)
  game.play_game
end

# Script to run the gameplay
dictionary_file_path = 'lib/resources/words.txt'
existing_games_file_path = 'lib/saved_games/'
existing_games = Dir.empty?(existing_games_file_path)

if !existing_games
  get_player_choice(existing_games_file_path, dictionary_file_path)
else
  play_new_game(existing_games_file_path, dictionary_file_path)
end
