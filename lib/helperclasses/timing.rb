module HelperClasses
  class Timing
    def initialize(dbg = 0)
      @dbg_lvl = dbg
      @time = Time.now
    end

    def probe(msg = '')
      t = sprintf('%f3', (Time.now - @time).to_f)
      dputs(@dbg_lvl) { "#{msg}: #{t}" }
      @time = Time.now
    end

    def self.measure(msg = '', dbg = 0)
      t = Timing.new(dbg)
      ret = yield
      t.probe(msg)
      ret
    end
  end
end