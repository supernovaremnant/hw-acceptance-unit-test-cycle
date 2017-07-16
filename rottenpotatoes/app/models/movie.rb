class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def same_director(director_name)
    if !director_name.nil? and !director_name.eql? ""
      return nil 
    else 
      return Movie.where( :director => director_name )
    end 
  end
end
