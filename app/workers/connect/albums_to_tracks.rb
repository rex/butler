module Connect
  class AlbumsToTracks
    include Sidekiq::Worker

    def perform(dir)
      #
    end
  end
end