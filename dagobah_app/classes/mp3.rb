require 'id3tag'

module Track
  class Mp3
    attr_reader :frames
    attr_accessor :file

    def initialize(file)
      @file = file
      ID3Tag.read(File.open(file)) do |id3tag|
        @track = id3tag
        @frames = id3tag.frames
      end
    end

    def file(file)
      @file = file
    end

    def md5sum
      Digest::MD5.file(@file).hexdigest
    end

    def artist
      # puts "Fetching artist: #{property(:TPE1)} (#{property(:TPE1).class})"
      property(:TPE1)
    end

    def album_artist
      property(:TPE2)
    end

    def title
      property(:TIT2)
    end

    def album
      property(:TALB)
    end

    def year
      property(:TYER)
    end

    def track_number
      property(:TRCK)
    end

    def encoder
      property(:TENC)
    end

    def genre
      property(:TCON)
    end

    def language
      property(:TLAN)
    end

    def label
      property(:TPUB)
    end

    def comments
      property(:COMM, multi: true)
    end

    def bpm
      property(:TBPM)
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
        language: language,
        label: label,
        comments: comments,
        bpm: bpm,
        file: @file,
        md5sum: md5sum
      }
    end

    def excerpt
      " > #{@file} \n\t -> #{artist} - #{title} from #{album} (#{label}, #{year})"
    end

    def property(property, params = {})
      begin
        frame = @track.get_frames(property)
        unless frame.empty?
          if params[:multi]
            frame.map(&:content)
          else
            get_frame_content(frame)
          end
        else
          nil
        end
      rescue
        nil
      end
    end

    def get_frame_content(frame)
      unless frame.empty?
        content = frame.first.content
        if content.is_a? Array
          content.first
        else
          content
        end
      else
        nil
      end
    end
  end
end