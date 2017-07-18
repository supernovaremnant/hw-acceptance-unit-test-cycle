describe Movie do
  
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
    @m.save
    list.push(@m)
  end 

  describe 'def same_director( _name )' do
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
  
  describe 'def initialize' do 
    it 'should be defined' do 
      expect { Movie }.not_to raise_error 
    end 
    
    describe 'getters and setters' do 
      before(:each) {@movie = Movie.new(:title => "Apple", :director => "Michael", :description => "Interesting")}
      
      it 'set title' do 
        expect(@movie.title).to eq('Apple')
      end
      
      it 'set description' do 
        expect(@movie.description).to eq("Interesting")
      end 
      
      it 'set director' do 
        expect(@movie.director).to eq("Michael")
      end 
      
      it 'can change title' do
        @movie.title = "Orange"
        expect(@movie.title).to eq("Orange")
      end 
      
      it 'can change description' do 
        @movie.description = "Funny"
        expect(@movie.description).to eq("Funny")
      end 
      
      it 'can change director' do 
        @movie.director = 'Joyce'
        expect(@movie.director).to eq("Joyce")
      end 
    end 
    
    describe 'def self.all_ratings' do 
      it 'self.all_ratings' do 
        assert(Movie.all_ratings.eql? %w(G PG PG-13 NC-17 R) ) 
      end 
    end 
  end 
end

