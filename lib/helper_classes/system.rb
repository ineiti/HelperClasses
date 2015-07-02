# System-interaction for different flavours of Unix
require 'helper_classes/dputs'

module HelperClasses
  module System
    extend self
    extend HelperClasses::DPuts
    include HelperClasses::DPuts

    def run_str(cmd)
      dputs(3) { "Running command --#{cmd}--" }
      %x[ #{cmd} ]
    end

    def run_bool(cmd)
      dputs(3) { "Running command --#{cmd}--" }
      Kernel.system("#{cmd} > /dev/null 2>&1")
    end

    def exists?(cmd)
      dputs(3) { "Exist command --#{cmd}--?" }
      run_bool("which #{cmd} > /dev/null 2>&1")
    end

    def rescue_all(msg = 'Error')
      begin
        yield
      rescue StandardError => e
        dputs(0) { "#{Time.now.strftime('%a %y.%m.%d-%H:%M:%S')} - #{msg}" }
        dputs(0) { "#{e.inspect}" }
        dputs(0) { "#{e.to_s}" }
        e.backtrace.each { |l| dputs(0) { l } }
        return false
      end
    end

    def iptables(*args, check: false)
      if !@iptables_cmd
        if System.exists?('iptables')
          @iptables_cmd = 'iptables'
          @iptables_wait = (System.run_str('iptables --help') =~ /\s-w\s/) ? '-w' : ''
        else
          @iptables_cmd = ''
        end
      end

      if @iptables_cmd != ''
        if check
          dp( "Checking #{@iptables_wait} #{args.join(' ')}")
          System.run_bool("#{@iptables_cmd} #{@iptables_wait} #{args.join(' ')} 2>/dev/null")
        else
          System.run_str("#{@iptables_cmd} #{@iptables_wait} #{args.join(' ')}")
        end
      else
        return ''
      end
    end

    # Returns the stratum of the ntpd-synchronization:
    # 16 -> not synchronized
    # 2..15 -> synchronized
    def ntpdstratum
      ret = System.run_str('ntpq -c "rv 0 stratum"')
      return 16 if ret =~ /connection refused/i
      stratum = ret.gsub(/.*=/, '')
      return stratum.to_i
    end

    # Waits for NTP to be synchronized or for _n_ seconds
    def ntpd_wait(n = 60)
      Thread.new {
        System.rescue_all do
          (1..n).each {
            break if System.ntpdoffset
            sleep 1
          }
          yield
        end
      }
    end

    # Returns the offset of the ntpd-synchronization:
    # nil -> not synchronized
    # else -> synchronization in ms
    def ntpdoffset
      ret = System.run_str('ntpq -c "rv 0 stratum,offset"')
      return nil if ret =~ /connection refused/i
      stratum, offset = ret.split(/, /).collect { |s| s.gsub(/.*=/, '') }
      return nil if stratum == '16'
      return offset.to_f
    end
  end
end