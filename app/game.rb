class Game 

  attr_accessor :id, :file_path, :file, :dictionary, :hangman_word, :hangman_word_length, :current_hangman_word, :letters_guessed, :guesses_remaining, :game_over

  def initialize (file_path)
    @id = rand(10000)
    @file_path = file_path
    @file = nil
    @dictionary = nil
    @hangman_word = nil
    @hangman_word_length = nil
    @current_hangman_word = nil
    @letters_guessed = []
    @guesses_remaining = 10
    @game_over = false
  end

  def setup_game(dictionary)
    create_file
    add_game_dictionary(dictionary)
    setup_current_hangman_word
    puts "The word is #{@hangman_word_length} letters."
    print_current_game_information
  end

  def play_game
    while !game_over && @guesses_remaining.positive?
      get_player_guess
    end
  end

  private

  def create_file
    @file_path = @file_path << @id.to_s << '.txt'
    @file = File.open(@file_path,"w")
    @file.close
  end

  def add_game_dictionary(dictionary)
    @dictionary = dictionary
    @hangman_word = dictionary.dictionary_word
    @hangman_word_length = @hangman_word.length
  end

  def setup_current_hangman_word
    @current_hangman_word = Array.new(@hangman_word_length,"_")
  end

  def print_current_game_information
    puts "\n"
    puts "You have #{@guesses_remaining} guesses remaining!"
    puts "This is your current hangman: #{@current_hangman_word.join(" ")}"
    puts "You have guessed these letters: #{@letters_guessed.join(", ")}"
  end

  def get_player_guess
    puts 'What is your guess? Single letters please.'
    guess = gets.chomp.downcase
    if valid_guess(guess)
      play_guess(guess)
      print_current_game_information
      check_game_over
    else
      puts "Invalid guess"
      get_player_guess
    end
  end

  def valid_guess(guess)
    if guess.match?(/[a-z]/) && guess.length == 1 && !@letters_guessed.include?(guess)
      true
    else
      false
    end
  end

  def play_guess(guess)
    @letters_guessed << guess
    if @hangman_word.include?(guess)
      arr = @hangman_word.split("")
      matching_index = arr.each_with_index.select {|char,index| arr[index] == guess }
      matching_index.each do |i|
        index = i[1]
        @current_hangman_word[index] = guess
      end
    end
    @guesses_remaining -= 1
  end

  def check_game_over
    if @current_hangman_word.join('') == @hangman_word
      puts "\nYou win! The word was #{@hangman_word}!"
      @game_over = true
    elsif @guesses_remaining == 0
      puts "\nYou lose! The word was #{@hangman_word}!"
      @game_over = true
    else
      puts "Not quite, keep playing!"
    end
  end

end