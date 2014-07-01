class HomeController < ApplicationController
  def index
    # @tracks = Track.all
    @artists = Artist.all
    @albums = Album.all
  end
end
