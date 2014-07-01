class Helpers
  def self.header(text)
    puts "\n------------\n\n#{text.upcase}\n-------\n"
  end

  def self.subheader(text)
    puts " ---> #{text}\n====="
  end

  def self.to_object_id(str)
    BSON::ObjectId.from_string(str)
  end

  def self.progress_bar(title, total)
    ProgressBar.create(
      :title => title,
      :total => total,
      :progress_mark => "0",
      :remainder_mark => "~",
      :throttle_rate => 0.5,
      :format => "%t |%B| %c/%C (%p%%, %r/sec) | %a / %e"
    )
  end
end