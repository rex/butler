class Album
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String

  has_many :tracks
  has_and_belongs_to_many :artists

  index(name: 1)
  index(track_ids: 1)
  index(artist_ids: 1)

  def add_track(track)
    unless track.nil?
      unless self.track_ids.include? track[:_id]
        self.tracks.push(track)
      end
    end
  end

  def add_artist(artist)
    unless artist.nil?
      unless self.artist_ids.include? artist[:_id]
        self.artists.push(artist)
      end
    end
  end
end