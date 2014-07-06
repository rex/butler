module Connect
  class ArtistsToTracks
    include Sidekiq::Worker

    def perform(dir)
      #
    end
  end
end