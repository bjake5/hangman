# frozen_string_literal: true
# This is a class to organize the dictionary-related methods to support a hangman game.

class Dictionary
  attr_accessor :game, :file_path, :dictionary, :dictionary_word

  def initialize(game, file_path)
    @game = game
    @file_path = file_path
    @dictionary_word = nil
    @dictionary = nil
  end

  # This is a public method to setup a dictionary.
  def setup_dictionary
    create_dictionary
    choose_hangman_word
  end

  private

  # This is a private method to create a dictionary from a word list on an external file.
  def create_dictionary
    file = File.open(@file_path)
    @dictionary = file.readlines.map(&:chomp)
    file.close
    @dictionary = @dictionary.filter { |word| word.length > 5 && word.length < 12 }
  end

  # This is a private method to randomly choose the hangman word from the dictionary.
  def choose_hangman_word
    dictionary_length = @dictionary.length
    @dictionary_word = @dictionary[rand(dictionary_length)]
    'loading words...reviewing possibilities...word chosen!'
  end
end
