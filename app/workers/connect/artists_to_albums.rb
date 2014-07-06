module Connect
  class ArtistsToAlbums
    include Sidekiq::Worker

    def perform
      Album.each do |album|
        album.artists.each do |artist|
          artist.add_album(album)
        end
      end
    end
  end
end