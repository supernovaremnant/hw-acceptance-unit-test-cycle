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
      # it 'search director info' do  
      #   get 'search_director', {:id => '1'}
      #   expect(response).to render_template(:search_director)
      # end
      
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