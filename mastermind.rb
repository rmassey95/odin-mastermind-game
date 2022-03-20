class Game
  attr_accessor :code, :colours, :guess, :compare_arr, :bad_guesses
  attr_reader :user_coding
  def initialize()
    @guess = Array.new()
    @code = Array.new()
    @colours = {0 => 'red',1 => 'blue', 2=> 'yellow', 3 => 'green', 4 => 'white', 5 => 'black'}
    @compare_arr = Array.new()
    @user_coding
    
    puts "Type 'code' to create the code or 'guess' to guess a computer generated code"
    choice = gets.chomp
    if choice.downcase == 'guess'
      @user_coding = false
      computer_codemaker()
    elsif choice.downcase == 'code'
      @bad_guesses = Array.new()
      @user_coding = true
      user_codemaker()
    end
  end

  def player_guess()
    puts "Enter your four guesses, seperated by spaces"
    @guess = gets.chomp.split(' ')
    compare_guess()
  end

  def computer_guess()
    if @compare_arr.count == 4
      @compare_arr.each_index do |n|
        if @compare_arr[n] == 1
          @compare_arr.each_index do |i|
            if i != n
              if compare_arr[i] == 0
                @guess[i] = @guess[n]
                @compare_arr[i] = 2
                break
              elsif compare_arr[i] == 1
                temp = @guess[i] 
                @guess[i] = @guess[n]
                @guess[n] = temp
                @compare_arr[i] = 2
                @compare_arr[n] = 2
                break
              end
            end
          end
        elsif @compare_arr[n] == 0 && @guess.count(@guess[n]) > @code.count(@guess[n])
          unless @bad_guesses.include?(@guess[n])
            @bad_guesses.push(@guess[n])
          end
          while @bad_guesses.include?(@guess[n]) do
            @guess[n] = colour_return(random_num)
          end
        end
      end
    else
      for i in 0..3
        @guess.push(random_num)
        @guess[i] = colour_return(@guess[i])
      end
    end
    compare_guess()
  end

  def display()
    puts "MATCHES: #{@compare_arr.count(2)}"
    puts "PARTIALS: #{@compare_arr.count(1)}"
  end

  def check_win?()
    if @compare_arr.count(2) == 4
      puts "PLAYER HAS WON!"
      return true
    else
      return false
    end
  end

  private 
  def computer_codemaker()
    for i in 0..3
      @code.push(random_num())
      @code[i] = colour_return(@code[i])
    end
    p @code
  end

  def random_num()
    return Random.rand(0..5)
  end

  def colour_return(num)
    return @colours[num]
  end

  def user_codemaker()
    puts "Enter code seperated by spaces: "
    @code = gets.chomp.split(' ')
    p @code
  end

  def compare_guess()
    @compare_arr = []
    counts = Hash.new()
    matches = Array.new()
    for i in 0..3
      if counts[@guess[i]] == nil
        counts[@guess[i]] = 1
      else
        counts[@guess[i]] += 1
      end
      if @guess[i] == @code[i]
        @compare_arr.push(2)
        matches.push(@guess[i])
      elsif @code.count(@guess[i]) >= 1
        @compare_arr.push(1)
      else
        @compare_arr.push(0)
      end
    end
    if @compare_arr.count(1) > 0
      for n in 0..@compare_arr.count
        if @compare_arr[n] == 1
          @code.each_index do |x|
            if @guess[x] == @code[x] && @guess[x] == @guess[n]
              if counts[@guess[n]] == 1
                counts[@guess[n]] = 0
              else
                counts[@guess[n]] -= 1
              end
            end
          end

          if counts[@guess[n]] == 0
            @compare_arr[n] = 0
          elsif counts[@guess[n]] > @code.count(@guess[n])
            @compare_arr[n] = 0
            counts[@guess[n]] -= 1
          elsif matches.count(@guess[n]) >= counts[@guess[n]]
            @compare_arr[n] = 0
          end

        end
      end
    end
    display()
  end

end

win = false
cont = true

while cont
  new_game = Game.new()

  if new_game.user_coding 
    for i in 1..12
      new_game.computer_guess()
      win = new_game.check_win?()
      if win
        break
      end
    end

  else
    for i in 1...12
      new_game.player_guess()
      win = new_game.check_win?()
      if win
        break
      end
    end
  end
  puts "Would you like to play again? y or n?"
  user_input = gets.chomp
  if user_input == 'n'
    cont = false
  end
end
