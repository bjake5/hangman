require_relative 'app/dictionary'
require_relative 'app/game'

def get_player_choice(dictionary_file_path)
  puts "\nDo you want to continue a previous game? Y/N"
  choice = gets.chomp
  if choice == "Y"
    load_previous_game 
  elsif choice == "N"
    play_new_game(existing_games_file_path, dictionary_file_path)
  else
    get_player_choice
  end
end

def play_new_game(existing_games_file_path, dictionary_file_path)
  puts 'Starting a new game...'
  game = Game.new(existing_games_file_path)
  dictionary = Dictionary.new(game, dictionary_file_path)
  dictionary.setup_dictionary
  game.setup_game(dictionary)
  game.play_game
end

dictionary_file_path = 'lib/resources/words.txt'
existing_games_file_path = 'lib/saved_games/'
existing_games = Dir.empty?(existing_games_file_path)

if !existing_games
  get_player_choice(dictionary_file_path)
else
  play_new_game(existing_games_file_path, dictionary_file_path)
end
