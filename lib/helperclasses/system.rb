# System-interaction for different flavours of Unix
require 'helperclasses/dputs'

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

    def rescue_all(msg = nil)
      begin
        yield
      rescue Exception => e
        msg and dputs(0) { msg }
        dputs(0) { "#{e.inspect}" }
        dputs(0) { "#{e.to_s}" }
        e.backtrace.each { |l| dputs(0) { l } }
      end
    end

    def iptables(*args)
      if !@iptables_cmd
        if System.exists?('iptables')
          @iptables_cmd = 'iptables'
          @iptables_wait = (System.run_str('iptables --help') =~ /\s-w\s/) ? '-w' : ''
        else
          @iptables_cmd = ''
        end
      end

      if @iptables_cmd != ''
        System.run_str(dp "#{@iptables_cmd} #{@iptables_wait} #{args.join(' ')}")
      else
        return ''
      end
    end
  end
end