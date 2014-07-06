module Populate
  class Albums
    include Sidekiq::Worker

    def perform
      Track.each do |track|
        unless track[:album_name].nil?
          unless track[:artist_name].nil?
            artist = Artist.where(name: Utils::Helpers.sanitize(track[:artist_name])).first_or_create
          else
            artist = Artist.unknown.first_or_create
          end

          album = Album.where(name: Utils::Helpers.sanitize(track[:album_name])).first_or_create

          unless album.nil?
            album.add_artist(artist)
            album.add_track(track)
            track.set_album(album)
          end

          track.set_artist(artist)
        end
      end
    end
  end
end