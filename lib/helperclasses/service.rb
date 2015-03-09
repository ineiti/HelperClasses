require 'helperclasses/dputs'
require 'helperclasses/system'

module HelperClasses
  module Service
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

    def service_get(service)
      services = {
          samba: {ArchLinux: %w( smbd nmbd ), Ubuntu: %w(smbd nmbd)},
          cups: {ArchLinux: 'org.cups.cupsd', Ubuntu: 'cupsd'},
          dnsmasq: {ArchLinux: 'dnsmasq', Ubuntu: 'dnsmasq'}
      }[service.to_sym]
      services or return nil
      services[@system]
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
                            Ubuntu: '/etc/init.d/## start',
                            MacOSX: nil}
      )
    end

    def stop(service)
      service_run(service, {ArchLinux: 'systemctl stop ##',
                            Ubuntu: '/etc/init.d/## stop',
                            MacOSX: nil}
      )
    end

    def restart(service)
      service_run(service, {ArchLinux: 'systemctl restart ##',
                            Ubuntu: '/etc/init.d/## restart',
                            MacOSX: nil}
      )
    end

    def enable(service)
      service_run(service, {ArchLinux: 'systemctl enable ##',
                            Ubuntu: nil,
                            MacOSX: nil}
      )
    end

    def disable(service)
      service_run(service, {ArchLinux: 'systemctl disable ##',
                            Ubuntu: nil,
                            MacOSX: nil}
      )
    end

    def enable_start(service)
      enable(service)
      start(service)
    end

    def stop_disable(service)
      disable(service)
      stop(service)
    end
  end
end