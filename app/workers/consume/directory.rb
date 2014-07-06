module Consume
  class Directory
    include Sidekiq::Worker

    def perform(path)
      puts "Consuming directory: #{path}, pausing queue."
      Sidekiq::Queue['default'].pause
      puts " > Queue paused? #{Sidekiq::Queue['default'].paused?}"

      Dir.glob("#{path}/**/*.{mp3,m4a}").each do |file|
        if File.file?(file)
          Consume::DirectoryItem.perform_async(file)
        end
      end

      Populate::Artists.perform_async
      Populate::Albums.perform_async
      Connect::ArtistsToAlbums.perform_async
      Aggregate::DetectDuplicates.perform_async
      Aggregate::DetectMissing.perform_async

      puts "All jobs queued, Unpausing queue!"
      Sidekiq::Queue['default'].unpause
    end
  end
end