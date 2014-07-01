module Dagobah
  class DB
    def self.create_indexes
      Helpers.header("Creating MongoDB Indexes")
      $session.with(safe: true) do |safe|
        tracks = safe[:tracks]
        artists = safe[:artists]
        albums = safe[:albums]

        artists.indexes.create(name: 1)
        artists.indexes.create(albums: 1)
        artists.indexes.create(tracks: 1)

        albums.indexes.create(name: 1)
        albums.indexes.create(tracks: 1)
        albums.indexes.create(artists: 1)

        tracks.indexes.create(artist: 1)
        # tracks.indexes.create(album_artist: 1)
        tracks.indexes.create(album: 1)
        tracks.indexes.create(title: 1)
        tracks.indexes.create(md5sum: 1)
      end
    end
  end
end