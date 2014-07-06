module Utils
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

    def self.sanitize(str)
      str.chomp.strip.to_s
    end
  end
end