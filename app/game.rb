# frozen_string_literal: true
# This is a class to organize the primary gameplay methods, including file-related operations.

class Game
  attr_accessor :id, :file_path, :file, :dictionary, :hangman_word, :hangman_word_length, :current_hangman_word,
                :letters_guessed, :guesses_remaining, :game_over

  def initialize(file_path)
    @id = rand(10_000)
    @file_path = file_path
    @hangman_word = nil
    @hangman_word_length = nil
    @current_hangman_word = nil
    @letters_guessed = []
    @guesses_remaining = 10
    @game_over = false
  end

  # This is a public method to setup a new game by linking a new dictionary / hangman word.
  def setup_game(dictionary)
    create_file
    add_game_dictionary(dictionary)
    setup_current_hangman_word
    puts "The word is #{@hangman_word_length} letters."
    print_current_game_information
  end

  # This is a public method to play the game while the game is not over
  def play_game
    get_player_guess until game_over
  end

  # This is a public method to load existing game data from a file.
  def load_game(game_data)
    @id = id
    @file_path = game_data.file_path
    @hangman_word = game_data.hangman_word
    @hangman_word_length = game_data.hangman_word_length
    @current_hangman_word = game_data.current_hangman_word
    @letters_guessed = game_data.letters_guessed
    @guesses_remaining = game_data.guesses_remaining
    @game_over = game_data.game_over
  end

  # This is a public method to print the current game information for player context.
  def print_current_game_information
    puts
    puts "You have #{@guesses_remaining} guesses remaining!"
    puts "This is your current hangman: #{@current_hangman_word.join(' ')}"
    puts "You have guessed these letters: #{@letters_guessed.join(', ')}"
  end

  private

  # This is a private method to create the file to save game data.
  def create_file
    marshalled_game_data = Marshal.dump(self)
    @file_path = @file_path << @id.to_s << '.txt'
    file = File.open(@file_path, 'w')
    file.print marshalled_game_data
    file.close
  end

  # This is a private method to save the game data to existing file.
  def save_file
    marshalled_game_data = Marshal.dump(self)
    File.truncate(@file_path, 0)
    file = File.open(@file_path, 'w')
    file.print marshalled_game_data
    file.close
  end

  # This is a private method to link the chosen hangman word to game and determine length of word for display purposes.
  def add_game_dictionary(dictionary)
    @hangman_word = dictionary.dictionary_word
    @hangman_word_length = @hangman_word.length
  end

  # This is a private method to organize hangman word display using conventional underscores for player guessing purposes.
  def setup_current_hangman_word
    @current_hangman_word = Array.new(@hangman_word_length, '_')
  end

  # This is a private method to get the player's letter choice and action the guess if it's valid.
  def get_player_guess
    puts 'What is your guess? Single letters please.'
    guess = gets.chomp.downcase
    if valid_guess(guess)
      play_guess(guess)
      print_current_game_information
      save_file
      check_game_over
    else
      puts 'Invalid guess'
      get_player_guess
    end
  end

  # This is a private method to determine if a player's letter choice guess is valid.
  def valid_guess(guess)
    if guess.match?(/[a-z]/) && guess.length == 1 && !@letters_guessed.include?(guess)
      true
    else
      false
    end
  end

  # This is a private method to action the player's guess.
  def play_guess(guess)
    @letters_guessed << guess
    if @hangman_word.include?(guess)
      arr = @hangman_word.split('')
      matching_index = arr.each_with_index.select { |_char, index| arr[index] == guess }
      matching_index.each do |i|
        index = i[1]
        @current_hangman_word[index] = guess
      end
    end
    @guesses_remaining -= 1
  end

  # This is a private method to confirm if the game is over.
  # The two game over conditions are either the hangman word has been identified or there are no guesses remaining.
  def check_game_over
    if @current_hangman_word.join('') == @hangman_word
      puts "\nYou win! The word was #{@hangman_word}!"
      @game_over = true
      File.delete(@file_path)
    elsif @guesses_remaining.zero?
      puts "\nYou lose! The word was #{@hangman_word}!"
      @game_over = true
      File.delete(@file_path)
    else
      puts 'Not quite, keep playing!'
    end
  end
end
