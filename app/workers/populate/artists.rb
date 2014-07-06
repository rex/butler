module Populate
  class Artists
    include Sidekiq::Worker

    def perform
      Track.each do |track|
        unless track[:artist_name].nil?
          artist = Artist.where(name: Utils::Helpers.sanitize(track[:artist_name])).first_or_create
        else
          artist = Artist.unknown.first_or_create
        end

        artist.add_track(track)
      end
    end
  end
end