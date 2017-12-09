require 'helper_classes/dputs'
require 'helper_classes/system'

module HelperClasses
  module Platform
    attr_accessor :system, :services, :has_systemd

    extend self
    extend HelperClasses::DPuts
    @system = case System.run_str 'uname -a'
                when /ARCH/
                  :ArchLinux
                when /Ubuntu/
                  :Ubuntu
                when /Darwin/
                  :MacOSX
                else
                  nil
              end

    @has_systemd = System.run_bool('test -x /bin/systemctl')

    @services = {
        samba: {ArchLinux: %w( smbd nmbd ), Ubuntu: %w(smbd nmbd)},
        cups: {ArchLinux: 'org.cups.cupsd', Ubuntu: 'cupsd'},
        net_start: {ArchLinux: '/usr/bin/netctl start', Ubuntu: 'ifup'},
        net_stop: {ArchLinux: '/usr/bin/netctl stop', Ubuntu: 'ifdown'},
    }

    def service_get(service)
      begin
        @services[service.to_sym][@system]
      rescue NoMethodError => _e
        service.to_s
      end
    end

    def service_run(service, cmd)
      return unless @system
      if !cmd
        log_msg :Services, "System #{@system} can't start services"
        return false
      end
      service_name = service_get(service)
      if !service_name
        log_msg :Services, "System #{@system} doesn't have service #{service}"
        return false
      end
      cmd_system = cmd[@system]
      if !cmd_system
        log_msg :Services, "System #{@system} doesn't know how to do #{cmd}"
        return false
      end
      [service_name].flatten.each { |s|
        c = cmd_system.sub(/##/, s)
        if !System.run_bool(c)
          log_msg :Services, "Command #{c} failed"
          return false
        end
      }
    end

    def start(service)
      service_run(service, {ArchLinux: 'systemctl start ##',
                            Ubuntu: 'systemctl start ##',
                            MacOSX: nil}
      )
    end

    def stop(service)
      service_run(service, {ArchLinux: 'systemctl stop ##',
                            Ubuntu: 'systemctl stop ##',
                            MacOSX: nil}
      )
    end

    def restart(service)
      service_run(service, {ArchLinux: 'systemctl restart ##',
                            Ubuntu: 'systemctl restart ##',
                            MacOSX: nil}
      )
    end

    def enable(service)
      service_run(service, {ArchLinux: 'systemctl enable ##',
                            Ubuntu: 'systemctl enable ##',
                            MacOSX: nil}
      )
    end

    def disable(service)
      service_run(service, {ArchLinux: 'systemctl disable ##',
                            Ubuntu: 'systemctl disable ##',
                            MacOSX: nil}
      )
    end

    def reload
      return unless @system == :ArchLinux
      System.run_bool('/usr/bin/systemctl daemon-reload')
    end

    def daemon_reload
      reload
    end

    def enable_start(service)
      enable(service)
      start(service)
    end

    def stop_disable(service)
      disable(service)
      stop(service)
    end

    def net_start(iface)
      c = "#{@services[:net_start][@system]} #{iface}"
      if !System.run_bool(c)
        log_msg :Services, "Command #{c} failed"
        return false
      end
      return true
    end

    def net_stop(iface)
      c = "#{@services[:net_stop][@system]} #{iface}"
      if !System.run_bool(c)
        log_msg :Services, "Command #{c} failed"
        return false
      end
      return true
    end

    def net_restart(iface)
      net_stop(iface)
      net_start(iface)
    end

    def net_status(iface, dev)
      case @system
        when :ArchLinux
          return System.run_str("netctl status #{iface} | grep Active") =~ /: active/
        when :Ubuntu
          return System.run_str("ifconfig | grep #{dev}") != ''
        else
          return false
      end
    end
  end
end
