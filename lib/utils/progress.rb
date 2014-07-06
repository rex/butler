module Utils
  class Progress
    def get(title, total)
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
end