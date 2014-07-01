class Artist
  include Mongoid::Document

  has_many :tracks
  has_and_belongs_to_many :albums
end