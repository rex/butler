module Dagobah
  class Albums
    def self.populate
      # Helpers.header("Populating Albums")
      $session.with(safe: true) do |safe|
        artists = safe[:artists]
        tracks = safe[:tracks]
        albums = safe[:albums]

        progressbar = Helpers.progress_bar("Populating Albums", tracks.find.count)
        tracks.find.each do |track|
          unless track[:album].nil?
            artist = artists.find(name: track[:artist]).first
            unless artist.nil?
              artist_id = artist[:_id]
            else
              artist_id = nil
            end

            if albums.find(name: track[:album]).count == 0
              albums.insert({
                name: track[:album],
                track_ids: [Helpers.to_object_id(track[:_id])],
                artist_ids: [artist_id]
              })
            else
              albums.find(name: track[:album]).update('$addToSet' => {
                track_ids: Helpers.to_object_id(track[:_id]),
                artist_ids: artist_id
              })
            end

            # Add the album to the track
            album = albums.find(name: track[:album]).first
            tracks.find(_id: track[:_id]).update('$set' => {
              album_id: album[:_id],
              artist_id: artist_id
            })
          end

          progressbar.increment
        end
      end
    end
  end
end