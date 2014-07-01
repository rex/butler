module Dagobah
  class Artists
    def self.populate
      # Helpers.header("Populating Artists")
      $session.with(safe: true) do |safe|
        artists = safe[:artists]
        tracks = safe[:tracks]
        albums = safe[:albums]

        artists_populate_progressbar = Helpers.progress_bar("Populating Artists", tracks.find.count)
        tracks.find.each do |track|
          unless track[:artist].nil?
            # puts "Processing artist: #{track[:artist]} (#{track[:artist].class})"
            if artists.find(name: track[:artist]).count == 0
              artists.insert({
                name: track[:artist],
                album_ids: [],
                track_ids: [Helpers.to_object_id(track[:_id])]
              })
            else
              artists.find(name: track[:artist]).update('$addToSet' => {
                track_ids: Helpers.to_object_id(track[:_id])
              })
            end

            artists_populate_progressbar.increment
          end
        end
      end

      puts ""
    end

    def self.claim_albums
      # Helpers.header("Claiming Artist Albums")
      $session.with(safe: true) do |safe|
        artists = safe[:artists]
        tracks = safe[:tracks]
        albums = safe[:albums]

        artist_claim_albums_progressbar = Helpers.progress_bar("Claiming Artist Albums", albums.find.count)
        albums.find.each do |album|
          unless album[:artist_ids].empty?
            album[:artist_ids].each do |artist|
              artists.find(_id: artist).update('$addToSet' => {
                album_ids: album[:_id]
              })
            end
          end

          artist_claim_albums_progressbar.increment
        end
      end

      puts ""
    end
  end
end