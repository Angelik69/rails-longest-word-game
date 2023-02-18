require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [ ]
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @grid = params[:letters].dup
    @res = if !in_grid?
             "Sorry, but #{@word} can't be built out of #{params[:letters].gsub('', ', ')[1..-3]}"
           elsif !in_dict?
             "Sorry, but #{@word} does not seem to be a valid english word..."
           else
             "Congratulations! #{@word} is a valid english word!"
           end
  end

  private

  def in_grid?
    @word.each_char do |c|
      return false unless @grid.include? c

      @grid.sub!(c, '')
    end
    true
  end

  def in_dict?
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read)['found'] == true
  end
end
