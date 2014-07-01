require 'moped'
require 'taglib'
require 'ruby-progressbar'
require_relative('classes/audio_file')
require_relative('classes/mp3')
require_relative('classes/m4a')
require_relative('classes/db')
require_relative('classes/helpers')
require_relative('classes/albums')
require_relative('classes/artists')
require_relative('classes/tracks')

drop_collections = true
database = "butler_r2d2_test"
music_dir = "/Volumes/R2D2/Media/Music"

Helpers.header("Initializing Dagobah Music Cleanup")

Helpers.subheader("Connecting to MongoDB")
$session = Moped::Session.new([ "127.0.0.1:27017" ])
$session.use database

if drop_collections
  Helpers.subheader("Dropping existing collections")
  $session.collection_names.each do |coll|
    puts "Dropping collection: #{coll}"
    $session[coll].drop
  end
end

Helpers.subheader("Starting Dagobah Indexing Application!")
$session.with(safe: true) do |safe|
  Dagobah::DB.create_indexes
  Dagobah::Tracks.populate(music_dir)
  Dagobah::Tracks.detect_duplicates
  # Dagobah::Tracks.cleanup
  Dagobah::Artists.populate
  Dagobah::Albums.populate
  Dagobah::Artists.claim_albums

  Helpers.header("Dagobah Indexing Application Complete! Statistics:")
  Helpers.subheader("Tracks Processed: #{safe[:tracks].find.count}")
  Helpers.subheader("Artists Processed: #{safe[:artists].find.count}")
  Helpers.subheader("Albums Processed: #{safe[:albums].find.count}")
  Helpers.subheader("Track Errors: #{safe[:track_errors].find.count}")
  Helpers.subheader("Tracks without Artists: #{safe[:tracks].find(artist: nil).count}")
  Helpers.subheader("Tracks without Artist or Album Artist: #{safe[:tracks].find(artist: nil, album_artist: nil).count}")
  Helpers.subheader("Tracks without Album: #{safe[:tracks].find(album: nil).count}")
  Helpers.subheader("Tracks without Title: #{safe[:tracks].find(title: nil).count}")
end