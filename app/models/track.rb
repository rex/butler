class Track
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :missing, type: Boolean, default: false
  field :file, type: String

  # has_one :artist
  # has_one :album
  belongs_to :album
  belongs_to :artist

  index(artist: 1)
  index(album: 1)
  index(title: 1)
  index(md5sum: 1)
  index(missing: 1)
  index(file: 1)

  scope :missing, -> { where(missing: true) }

  def set_album(album)
    self.album = album
  end

  def set_artist(artist)
    self.artist = artist
  end
end