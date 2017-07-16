class Movie < ActiveRecord::Base
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def same_director( _name )
    if _name.nil? and !_name.eql? ""
      return nil 
    else 
      return Movie.where( :director => _name )
    end 
  end
  
end
