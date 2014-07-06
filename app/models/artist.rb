class Artist
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String

  has_many :tracks
  has_and_belongs_to_many :albums

  index(name: 1)
  index(album_ids: 1)
  index(track_ids: 1)

  scope :unknown, ->{ where(name: "Unknown Artist") }

  def add_track(track)
    unless track.nil?
      unless self.track_ids.include? track[:_id]
        self.tracks.push(track)
      end
    end
  end

  def add_album(album)
    unless album.nil?
      unless self.album_ids.include? album[:_id]
        self.albums.push(album)
      end
    end
  end
end