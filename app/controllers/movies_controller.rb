class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def similar
    @all_ratings = Movie.all_ratings
    @selected_ratings = {}

    id = params[:id]
    @movie = Movie.find(id)

    if @movie.director.nil? || @movie.director.blank?
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    end

    @movies = Movie.find_all_by_director(@movie.director)
  end

  def index_old
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if params[:sort] != session[:sort]
      session[:sort] = sort
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

  def index
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]

    # redirect to RESTful path if session contains more info than provided in params
    if (!params[:ratings] && session[:ratings]) || (!params[:sort] && session[:sort])
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end

    query_base = Movie

    if session[:ratings]
      query_base = query_base.scoped(:conditions => { :rating => session[:ratings].keys })
    end

    if session[:sort]
      query_base = query_base.scoped(:order => session[:sort])
      case session[:sort]
      when 'title'
        ordering,@title_header = {:order => :title}, 'hilite'
      when 'release_date'
        ordering,@date_header = {:order => :release_date}, 'hilite'
      end
    end

    @movies = query_base.all

    @all_ratings = Movie.all_ratings

    if session[:ratings]
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = {}
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

