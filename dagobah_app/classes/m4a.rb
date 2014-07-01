require 'mp4info'

module Track
  class M4a
    attr_accessor :file

    def initialize(file)
      @file = file
      track = MP4Info.open(file)
      @data = track.instance_eval("@data_atoms")
      @info = track.instance_eval("@info_atoms")
    end

    def get(property)
      val = @data[property]
      if val.is_a? Array
        val.first
      else
        val
      end
    end

    def md5sum
      Digest::MD5.file(@file).hexdigest
    end

    def artist
      get "ART"
    end

    def album_artist
      get "WRT"
    end

    def title
      get "NAM"
    end

    def album
      get "ALB"
    end

    def year
      get "DAY"
    end

    def cover
      get "COVR"
    end

    def track_number
      get "TRKN"
    end

    def encoder
      get "TOO"
    end

    def genre
      get "GNRE"
    end

    def disk
      get "DISK"
    end

    def compilation
      get "CPIL"
    end

    def comments
      get "CMT"
    end

    def tempo
      get "TMPO"
    end

    def copyright
      get "CPRT"
    end

    def grouping
      get "GRP"
    end

    def rating
      get "RTNG"
    end

    def apple_id
      get "APID"
    end

    def bitrate
      @info["BITRATE"]
    end

    def frequency
      @info["FREQUENCY"]
    end

    def size
      @info["SIZE"]
    end

    def secs
      @info["SECS"]
    end

    def mm
      @info["MM"]
    end

    def ss
      @info["SS"]
    end

    def ms
      @info["MS"]
    end

    def time
      @info["TIME"]
    end

    def copyrighted?
      !@info["COPYRIGHT"].nil?
    end

    def encrypted?
      !@info["ENCRYPTED"].nil?
    end

    def excerpt
      " > #{@file} \n\t -> #{artist} - #{title} from #{album} (#{copyright}, #{year})"
    end

    def debug
      # puts " > File - #{@file}"
      puts "ALB - #{@data["ALB"]}" #   - Album
      puts "APID - #{@data["APID"]}" #  - Apple Store ID
      puts "ART - #{@data["ART"]}" #   - Artist
      puts "CMT - #{@data["CMT"]}" #   - Comment
      # puts "COVR - #{@data["COVR"]}" #  - Album art (typically jpeg data)
      puts "CPIL - #{@data["CPIL"]}" #  - Compilation (boolean)
      puts "CPRT - #{@data["CPRT"]}" #  - Copyright statement
      puts "DAY - #{@data["DAY"]}" #   - Year
      puts "DISK - #{@data["DISK"]}" #  - Disk number & total (Array of two integers)
      puts "GNRE - #{@data["GNRE"]}" #  - Genre
      puts "GRP - #{@data["GRP"]}" #   - Grouping
      puts "NAM - #{@data["NAM"]}" #   - Title
      puts "RTNG - #{@data["RTNG"]}" #  - Rating (integer)
      puts "TMPO - #{@data["TMPO"]}" #  - Tempo (integer)
      puts "TOO - #{@data["TOO"]}" #   - Encoder
      puts "TRKN - #{@data["TRKN"]}" #  - Track number & total (Array of two integers)
      puts "WRT - #{@data["WRT"]}" #   - Author or composer
      puts "VERSION - #{@info["VERSION"]}" #   - MPEG version (=4)
      puts "LAYER - #{@info["LAYER"]}" #     - Doesn't really mean antyhing, but here in case we need it
      puts "BITRATE - #{@info["BITRATE"]}" #   - Bitrate in kbps (average for VBR files)
      puts "FREQUENCY - #{@info["FREQUENCY"]}" # - Frequency in kHz
      puts "SIZE - #{@info["SIZE"]}" #      - Bytes in audio stream
      puts "SECS - #{@info["SECS"]}" #  - Total seconds, rounded to nearest second
      puts "MM - #{@info["MM"]}" #    - Minutes
      puts "SS - #{@info["SS"]}" #    - Leftover seconds
      puts "MS - #{@info["MS"]}" #    - Leftover milliseconds, rounded to nearest millisecond
      puts "TIME - #{@info["TIME"]}" #  - Time in MM:SS, rounded to nearest second
      puts "COPYRIGHT - #{@info["COPYRIGHT"]}" # - Non-nil if audio is copyrighted
      puts "ENCRYPTED - #{@info["ENCRYPTED"]}" # - Non-nil if audio data is encrypted
      puts "\n---------------\n\n"
    end

    def to_json
      {
        artist: artist,
        album_artist: album_artist,
        title: title,
        album: album,
        year: year,
        track_number: track_number,
        encoder: encoder,
        genre: genre,
        disk: disk,
        compilation: compilation,
        comments: comments,
        tempo: tempo,
        copyright: copyright,
        grouping: grouping,
        rating: rating,
        apple_id: apple_id,
        file: @file,
        bitrate: bitrate,
        frequency: frequency,
        size: size,
        secs: secs,
        mm: mm,
        ss: ss,
        ms: ms,
        time: time,
        copyrighted: copyrighted?,
        encrypted: encrypted?,
        md5sum: md5sum
      }
    end

    def excerpt
      puts " > #{@file} \n\t -> #{artist} - #{title} from #{album} (#{copyright}, #{year})"
    end
  end
end