require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end
  def new
    vowels = %w[A E I O U]
    consonants = %w[B C D F G H J K L M N O P Q R S T V W X Y Z]
    @letters = [vowels.sample(3), consonants.sample(7)].flatten.sort
  end

  def score
    @answer = params[:answer]
    @letras = params[:letters]
    @message = ""
    if verify_grid(@letras, @answer)
      if verify_word(@answer)
        @message = "Congratulations your score is #{total(@letras, @answer)}"
      else
        @message = "Your answer doesn't exist in english"
      end
    else
      @message = "Your answer doesn't match the given grid"
    end
  end

  def verify_grid(grid, try)
    try_splitted = try.upcase.chars
    try_splitted.each do |letter|
      return false if grid.include?(letter) == false
    end
    return true
  end

  def verify_word(try)
    url = "https://wagon-dictionary.herokuapp.com/#{try}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def total(grid, try)
    puntuacion = 5
    puntuacion += 5 if try.length >= grid.length / 2
    puntuacion += 5 if try.length >= (grid.length / 2) + 1
    puntuacion += 5 if try.length >= (grid.length / 2) + 2
    puntuacion += 5 if try.length >= (grid.length / 2) + 3
    return puntuacion
  end
end
