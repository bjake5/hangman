class Dictionary

  attr_accessor :game, :file_path, :dictionary, :dictionary_word

  def initialize(game, file_path)
    @game = game
    @file_path = file_path
    @dictionary_word = nil
    @dictionary = nil
  end

  def setup_dictionary
    create_dictionary
    choose_hangman_word
  end

  private

  def create_dictionary
    file = File.open(@file_path)
    @dictionary = file.readlines.map(&:chomp)
    file.close
    @dictionary = @dictionary.filter {|word| word.length > 5 && word.length < 12}
  end

  def choose_hangman_word
    dictionary_length = @dictionary.length
    @dictionary_word = @dictionary[rand(dictionary_length)]
    "loading words...reviewing possibilities...word chosen!"
  end

end