#!/usr/bin/env ruby


class TC_Service < Test::Unit::TestCase

  def setup
  end

  def test_service_get
    Service.system = :ArchLinux

    assert_equal %w(smbd nmbd), Service.service_get(:samba)
    assert_equal 'dnsmasq', Service.service_get(:dnsmasq)
  end
end
