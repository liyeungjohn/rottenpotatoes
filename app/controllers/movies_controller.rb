class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.allRatings

    if(params[:ratings] == nil && params[:order] == nil && (session[:ratings] != nil || session[:order] != nil))
	if(params[:ratings] == nil && session[:ratings] != nil)
	    params[:ratings] = session[:ratings]
	end
	if(params[:order] == nil && session[:order] != nil)
	    params[:order] = session[:order]
	end
	flash.keep
	redirect_to movies_path(:order => params[:order], :ratings => params[:ratings])
    
    else 
	session[:order] = params[:order]
    	session[:ratings] = params[:ratings]
	@curr_ratings = params[:ratings]? params[:ratings].keys : []

    	@movies = Movie.find(:all, :conditions => {:rating => (@curr_ratings==[]? @all_ratings : @curr_ratings)})

    	if(params[:order] == "title")
    	    @movies = Movie.find(:all, :order => "title", :conditions => {:rating => (@curr_ratings==[]? @all_ratings : @curr_ratings)})
    	end
    	if(params[:order] == "release_date")
    	    @movies = Movie.find(:all, :order => "release_date", :conditions => {:rating => (@curr_ratings==[]? @all_ratings : @curr_ratings)})	
    	end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
