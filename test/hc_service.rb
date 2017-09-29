#!/usr/bin/env ruby


class TC_Service < Test::Unit::TestCase

  def setup
  end

  def test_service_get
    Platform.system = :ArchLinux

    assert_equal %w(smbd nmbd), Platform.service_get(:samba)
    assert_equal 'dnsmasq', Platform.service_get(:dnsmasq)
  end
end
