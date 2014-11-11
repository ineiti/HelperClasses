# System-interaction for different flavours of Unix

module System
  extend self
  extend HelperClasses::DPuts

  def run_str( cmd )
    dputs(3){"Running command #{cmd}"}
    %x[ #{cmd} ]
  end

  def run_bool( cmd )
    dputs(3){"Running command #{cmd}"}
    Kernel.system( "#{cmd} > /dev/null 2>&1")
  end

  def exists?( cmd )
    dputs(3){"Exist command #{cmd}?"}
    run_bool( "which #{cmd} > /dev/null 2>&1")
  end
end