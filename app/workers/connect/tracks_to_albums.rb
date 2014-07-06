module Connect
  class TracksToAlbums
    include Sidekiq::Worker

    def perform(dir)
      #
    end
  end
end