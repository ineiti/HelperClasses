module HelperClasses
  module ReadConfig
    extend self

    # Searches in this order:
    # ~/.config
    # ~
    # /etc
    #
    # Returns nil if nothing found
    def file_name(file)
      %w( ~/.config ~ /etc ).each { |d|
        file_abs = File.expand_path("#{d}/#{file}")
        File.exists?(file_abs) and return file_abs
      }
      nil
    end

    # Very simple bash-reader, doesn't do array or multi-line configurations
    def bash(file, downcase = false)
      return nil unless File.exists? file
      IO.readlines(file).collect { |l|
        if l =~ /^#/
          nil
        elsif l =~ /([^ ]+)=(.*)/
          [(downcase ? $1.downcase : $1).to_sym, $2]
        end
      }.compact.to_h
    end

    # Ruby file-reader, returns created hash
    # THIS IS ABSOLUTELY INSECURE AND WILL EAT YOUR KITTENS!
    # It returns what the file returns at the end - so most probably you'll want
    # something like
    #
    #   { one: 1,
    #     two: 2 }
    #
    # in that config-file
    def ruby(file)
      return {} unless File.exists? file.to_s
      return eval(IO.readlines(file).join)
    end

    def json(file)
      p 'Not implemented yet'
      exit
    end
  end
end