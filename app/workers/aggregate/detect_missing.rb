module Aggregate
  class DetectMissing
    include Sidekiq::Worker

    def perform
      Track.each do |track|
        if File.exists?(track[:file])
          track.update(missing: true)
        else
          track.update(missing: false)
        end
      end
    end
  end
end