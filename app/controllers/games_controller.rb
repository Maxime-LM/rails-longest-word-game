require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @grid = params[:letters].upcase
    @attempt = params[:word]

    raise
    if match_grid(@attempt, @grid) == false
      @message = "Not in the grid : #{@grid}"
    elsif english_word?(@attempt) == false
      @message = "Not an English word"
    else
      @message = "Well Done!"
    end
  end

  private

  def api_request(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    JSON.parse(open(url).read)
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = JSON.parse(open(url).read)
    return response["found"] # == true
  end

  def match_grid(attempt, grid)
    return false if attempt.empty?

    letters = attempt.upcase.scan(/\w/)
    letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
  end
end
