require 'taglib'

module Structs
  class AudioFile
    def self.parse(file)
      TagLib::FileRef.open(file) do |fileref|
        unless fileref.null?
          tag = fileref.tag
          audio = fileref.audio_properties

          {
            bitrate: audio.bitrate,
            channels: audio.channels,
            length: audio.length,
            sample_rate: audio.sample_rate,
            album_name: tag.album,
            artist_name: tag.artist,
            comment: tag.comment,
            genre: tag.genre,
            title: tag.title,
            track: tag.track,
            year: tag.year,
            md5sum: Digest::MD5.file(file).hexdigest,
            type: File.extname(file),
            file: file
          }
        else
          nil
        end
      end
    end
  end
end