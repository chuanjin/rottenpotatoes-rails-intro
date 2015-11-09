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
    @all_ratings = Movie.ratings
    selected = params[:ratings]

    if selected
      @selected = selected.keys()
    elsif session[:selected]
      @selected = session[:selected]
    else
      @selected = @all_ratings
    end

    session[:selected] = @selected

    sort = params[:sort]

    if sort
      @sorted_by = sort.to_sym
      session[:sort] = @sorted_by
    elsif session[:sort]
      @sorted_by = session[:sort].to_sym
    else
      @sorted_by = ''
    end
 
    @movies = Movie.where(rating: @selected).order(@sorted_by)
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
