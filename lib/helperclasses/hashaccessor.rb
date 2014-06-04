module HelperClasses
  module HashAccessor
    refine Hash do
    end
  end
end

class Hash
  # Converts all keys of a hash to syms recursively
  def to_sym
    ret = {}
    each { |k, v|
      ret[k.to_sym] = v.class == Hash ? v.to_sym : v
    }
    ret
  end

  def to_sym!
    self.replace(to_sym())
  end

  def method_missing(s, *args)
    case s.to_s
      when "to_ary"
        super(s, args)
      when /^_.*[^=]$/
        key = s.to_s.sub(/^_{1,2}/, '').to_sym
        self.has_key? key and return self[key]
        self.has_key? key.to_s and return self[key.to_s]
        if s.to_s =~ /^__/
          return self[key] = {}
        else
          return nil
        end
      when /^_.*=$/
        key = /^_{1,2}(.*)=$/.match(s.to_s)[1].to_sym
        self.has_key? key and return self[key] = args[0]
        self.has_key? key.to_s and return self[key.to_s] = args[0]
        return self[key] = args[0]
      else
        super(s, args)
    end
  end
end