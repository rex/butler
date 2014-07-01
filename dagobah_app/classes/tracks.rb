module Dagobah
  class Tracks
    def self.populate(base_dir = "~/Music")
      $session.with(safe: true) do |safe|
        artists = safe[:artists]
        tracks = safe[:tracks]
        track_errors = safe[:track_errors]
        albums = safe[:albums]

        files_found = Dir.glob("#{base_dir}/**/*.{mp3,m4a}") #.first(500)

        populate_progressbar = Helpers.progress_bar("Populating Tracks", files_found.length)
        files_found.each do |file|
          if File.file?(file)
            ext = File.extname(file)

            begin
              track = Track::AudioFile.new(file)
              tracks.insert(track.to_json)
              populate_progressbar.increment
            rescue Exception => e
              track_errors.insert({
                file: file,
                error: e.class.to_s,
                message: e.message.to_s
              })
            end
          end
        end
      end

      puts ""
    end

    def self.detect_duplicates
      $session.with(safe: true) do |safe|
        tracks = safe[:tracks]

        duplicates_progressbar = Helpers.progress_bar("Detecting Duplicates", tracks.find.count)
        tracks.find.each do |track|
          dupes = tracks.find(md5sum: track[:md5sum]).map {|x| x[:_id]}
          if dupes.count > 1
            tracks.find(_id: Helpers.to_object_id(track[:_id])).update('$set' => {
              duplicates: dupes
            })
          end

          duplicates_progressbar.increment
        end
      end

      puts ""
    end

    def self.cleanup
      $session.with(safe: true) do |safe|
        artists = safe[:artists]
        tracks = safe[:tracks]
        track_errors = safe[:track_errors]
        albums = safe[:albums]

        cleanup_progressbar = Helpers.progress_bar("Cleaning Tracks", tracks.find.count)

        tracks.find.each do |track|
          cleanup_progressbar.increment

          ext = File.extname(track[:file])
          # track_number_array = track[:track_number]
          # unless track_number_array.nil?
          #   track_number_array = self.parse_range(track_number_array)

          #   track_current = track_number_array.first
          #   tracks_total = track_number_array.last
          # else
          #   track_current = nil
          #   tracks_total = nil
          # end

          # disk_array = track[:disk]
          # unless disk_array.nil?
          #   disk_array = self.parse_range(disk_array)
          #   disk_current = disk_array.first
          #   disks_total = disk_array.last
          # else
          #   disk_current = nil
          #   disks_total = nil
          # end

          # unless ['Various','Various Artists','Unknown','Unknown Artist','various','various artists'].include? track[:album_artist]
          #   artist = track[:album_artist],
          #   album_artist = nil
          # else
          #   artist = track[:artist]
          #   album_artist = track[:album_artist]
          # end

          tracks.find(_id: Helpers.to_object_id(track[:_id])).update('$set' => {
            type: ext,
            track_current: track_current,
            tracks_total: tracks_total,
            disk_current: disk_current,
            disks_total: disks_total
            # artist: artist,
            # album_artist: album_artist
          })
        end
      end
    end

    def self.parse_range(item)
      if item.is_a? String
        item.split("/")
      elsif item.is_a? Fixnum
        [item, nil]
      elsif item.is_a? Array
        item
      end
    end
  end
end