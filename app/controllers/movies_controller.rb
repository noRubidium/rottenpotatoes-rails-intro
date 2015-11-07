class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @redirect = false
    @all_ratings =  ['G','PG','PG-13','R']
    @checked = Hash.new
    @rating_list = Array.new
    if params[:sort]
      session[:sort] = params[:sort]
      @redirect = true
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @redirect = true
    end
    if @redirect
      redirect_to movies_path
    end
    
    sort = session[:sort]
    @ratings = session[:ratings]
    @movies = Movie.all
    if @ratings
      @all_ratings.each do |rating|
        if @ratings[rating] == '1'
          @checked[rating] = true
          @rating_list << rating
        else
          @checked[rating] = false
        end
      end
      @movies = Movie.where(rating: @rating_list)
    else
      @all_ratings.each do |rating|
        @checked[rating] = true
      end
      @movies = Movie.all
    end
    
    if sort == "title"
      @movies.order!("title")
      @title_class = "hilite"
    elsif sort == "release_date"
      @movies.order!("release_date")
      @release_date_class = "hilite"
    end
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
