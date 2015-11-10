class MoviesController < ApplicationController
  helper_method :hilight
  helper_method :checked_rating?

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

    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:order] = params[:order] unless params[:order].nil?

    if (params[:order].nil? && !session[:order].nil?) || (params[:ratings].nil? && !session[:ratings].nil?)
      redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
    elsif (session[:order].nil? && session[:ratings].nil?)
      @movies = Movie.all
    elsif session[:ratings].nil?
      @movies = Movie.all.order(session[:order])
    else
      @movies = Movie.where(rating: session[:ratings].keys).order(session[:order])
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


  def hilight(column)
    if(session[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end

  def checked_rating?(rating)
    checked_ratings = session[:ratings]
    return true if checked_ratings.nil?
    checked_ratings.include? rating
  end

end
