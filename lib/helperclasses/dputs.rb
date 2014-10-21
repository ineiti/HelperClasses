module HelperClasses
  require 'thread'
  require 'singleton'

  module DPuts
    extend self
    attr_accessor :mutex, :silent, :show_time, :terminal_width, :log_file
    
    @mutex = Mutex.new
    @silent = false
    @show_time = 60
    @terminal_width = 160
    @log_file = false
	
    def dputs_out( n, s, call )
      return if DPuts.silent
      if precision = DPuts.show_time
        $dputs_time ||= Time.now - 120
        now = Time.now
        show = false
        case precision
        when /sec/
          show = now.to_i != $dputs_time.to_i
        when /min/
          show = ( now.to_i / 60 ).floor != ( $dputs_time.to_i / 60 ).floor
        end
        show and puts "\n   *** It is now: " + 
          Time.now.strftime( "%Y-%m-%d %H:%M:%S" )
        $dputs_time = now
      end
      DPuts.mutex.synchronize do
        width = DPuts.terminal_width
        width -= 30.0
        file, func = call.split(" ")
        file = file[/^.*\/([^.]*)/, 1]
        who = ( ":" + n.to_s + ":" + file.to_s + 
            func.to_s ).ljust(30, [ "X","x","*","-","."," "][n])
        lines = []
        pos = 0
        while ( pos < s.length )
          len = width
          if s.length - pos > width
            len = s.rindex( /[, .;=&>]/, pos + width )
            len and len = len - pos + 1
            if len < width / 2
              len = width
            end
          end
          lines.push s.slice( pos, len )
          pos += len
        end
        puts who + " " + lines.shift.to_s
        lines.each{|l|
          puts " " * ( 32 ) + l
        }
      end
    end


    def dputs_getcaller
      caller(0)[2].sub(/:.*:in/, '').sub(/block .*in /,'')
    end

    def dputs_func
      $DPUTS_FUNCS ||= []
      $DPUTS_FUNCS.push(dputs_getcaller) unless $DPUTS_FUNCS.index(dputs_getcaller)
    end

    def dputs_unfunc
      $DPUTS_FUNCS ||= []
      $DPUTS_FUNCS.index(dputs_getcaller) and $DPUTS_FUNCS.delete(dputs_getcaller)
    end

    def dputs(n, &s)
      n *= -1 if ($DPUTS_FUNCS and $DPUTS_FUNCS.index(dputs_getcaller))
      if self.class.const_get(:DEBUG_LVL) >= n
        s = yield s
        dputs_out(n, s, caller(0)[1])
      end
    end

    def ddputs(n, &s)
      s = yield s
      #dp caller(0)
      dputs_out(-n, s, caller(0)[1])
    end

    def dp(s)
      dputs_out(0, s.class == String ? s : s.inspect, caller(0)[1])
      s
    end

    def log_msg( mod, msg )
      dputs( 1 ){ "Info from #{mod}: #{msg}" }
      return if not DPuts.log_file
      File.open( DPuts.log_file, "a" ){ |f|
        str = Time.now.strftime( "%a %y.%m.%d-%H:%M:%S #{mod}: #{msg}" )
        f.puts str
      }
    end

  end
end
