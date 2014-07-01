class Track
  include Mongoid::Document

  has_one :artist
  has_one :album
  belongs_to :album
  belongs_to :artist
end