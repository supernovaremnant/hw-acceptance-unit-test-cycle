require 'rails_helper'

describe MoviesController do
  list = Array.new 
  test_movies = {
    "Transformer_1" => "Michael Bay", 
    "Transformer_2" => "Michael Bay", 
    "Transformer_3" => "Michael Bay", 
    "Harry Porter"  => "Who cares", 
    "Big Apple"     => "", 
    "Happy New Year"=> ""
  }
  
  test_movies.each do |title, name|
    @m = Movie.new(:title => title, :director => name)
    list.push(@m)
  end 

  describe 'Searching movie with same director' do
    it 'When the specified movie has a director, it should find movies by the same director' do
      list.each_with_index do |val, index|
        
        result = val.same_director(val.director)
        result.each do |m|
          if !m.director.eql? val.director
            raise "search method wrong"
          end 
        end
  
      end 
    end 
    
    it 'When the specified movie has no director, it should not find movies by different directors' do 
      list.each_with_index do |val, index|
        
        if val.director.eql? ""
          # Director isn't specified 
          result = val.same_director(val.director)
          result.each do |m|
            if !m.director.eql? ""
              raise "search method wrong"
            end 
          end
        end 
      end
    end
  end
end
