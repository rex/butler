require 'taglib'
require 'yaml'

module Track
  class AudioFile
    def initialize(file)
      @file = file
      TagLib::FileRef.open(file) do |fileref|
        unless fileref.null?
          tag = fileref.tag
          audio = fileref.audio_properties

          @meta = {
            bitrate: audio.bitrate,
            channels: audio.channels,
            length: audio.length,
            sample_rate: audio.sample_rate,
            album: tag.album,
            artist: tag.artist,
            comment: tag.comment,
            genre: tag.genre,
            title: tag.title,
            track: tag.track,
            year: tag.year,
            md5sum: Digest::MD5.file(@file).hexdigest,
            artist_id: nil,
            album_id: nil,
            type: File.extname(@file),
            file: @file
          }
        end
      end
    end

    def to_json
      @meta
    end
  end
end