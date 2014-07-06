module Consume
  class DirectoryItem
    include Sidekiq::Worker

    def perform(path)
      if Track.where(file: path).exists?
        Track.where(file: path).update(build(path))
      else
        Track.create(build(path))
      end
    end

    def build(path)
      Structs::AudioFile.parse(path)
    end
  end
end