module Aggregate
  class DetectDuplicates
    include Sidekiq::Worker

    def perform
      Track.each do |track|
        dupes = Track.where(md5sum: track[:md5sum]).map {|x| x[:_id]}

        if dupes.count > 1
          track.update(duplicates: dupes)
        end
      end
    end
  end
end