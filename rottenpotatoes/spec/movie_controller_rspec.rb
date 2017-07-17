require "rails_helper"

RSpec.describe MoviesController, :type => :controller do
  
  describe "Movie Controller Method" do
    #create a new movie object before each test 
    before(:each) do
      @movie = Movie.new(:title => "The Hangover", :rating => 'R', :release_date => 1.years.ago, :description => 'Funny', :director => 'Todd Phillips')
      @movie.save
      
      @movie_without_director = Movie.new(:title => "The Hangover", :rating => 'R', :release_date => 1.years.ago, :description => 'Funny')
      @movie_without_director.save
    end
    
    describe "GET /index or /movies" do 
      it "renders the index template" do
        get 'index'
        expect(response).to render_template("index")
      end
      
      it "render with selected_ratings" do 
        get 'index', {:sort => "title"} 
        expect(response.body).to include "ratings"
      end 
      
      it "render with release_date" do 
        get 'index', {:sort => "release_date"} 
        expect(response.body).to include "release_date"
      end 
      
    end 
    
    describe "GET /show" do 
      it "show a detail page for a movie" do
        get 'show', {:id => '1'}
        expect(response).to render_template(:show)
      end
    end 
    
    describe "GET /show" do 
      it "show a detail page for a movie without director info" do
        get 'show', {:id => @movie_without_director.id}
        expect(response).to render_template(:show)
      end
    end 
    
    describe 'GET search_director' do 
      it 'search director info' do  
        get 'search_director', {:id => '1'}
        expect(response).to render_template(:search_director)
      end
      
      it 'search director info with invalid movie id ' do 
        get 'search_director', {:id => '100'}
        expect(response).to redirect_to(movies_path)
      end 
      
      it 'search director info with no movie id ' do 
        get 'search_director'
        expect(flash[:notice]).to match(/No such movie/)
        expect(response).to redirect_to(movies_path)
      end 
      
      it 'search director info with invalid movie id' do 
        get 'search_director', {:id => '-1'}
        expect(response).to redirect_to(movies_path)
      end 
      
      it 'search director info with no director info' do 
        get 'search_director', {:id => @movie_without_director.id}
        expect(flash[:notice]).to match(/Director info not available/)
        expect(response).to redirect_to(movies_path)
      end 
      
    end 
    
    describe 'GET /movies/:id/edit' do 
      it 'edit movie' do 
        get 'edit', { :id => '1' }
        expect(response).to render_template(:edit)
      end 
    end
    
    describe "PUT update/:id" do
      let(:attr) do 
        { :title => 'new title', :content => 'new content' }
      end
    
      before(:each) do
        put :update, :id => '1', :movie => attr
        @movie.reload
      end
    
      # it { expect(response).to redirect_to(@movie) }
      it { expect(@movie.title).to eql @movie[:title] }
      it { expect(@movie.description).to eql @movie[:description] }
      
    end
  
    describe 'POST create/:id' do 
      it 'create new movie' do 
        post 'create', movie: { title: "The Hangover 2", rating: "G", description: "Haha", release_date: 1.year.ago , director: "Michael"}
        expect(response).to redirect_to(movies_path)
      end 
    end
    
    describe 'DELETE destroy/:id' do 
      it 'delete an existing movie' do 
        delete 'destroy', {:id => @movie}
        expect(flash[:notice]).to match( /Movie (.*) deleted./)
        expect(response).to redirect_to(movies_path)
      end 
    end 
    
  end 
end

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
