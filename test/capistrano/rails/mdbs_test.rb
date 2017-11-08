require "test_helper"

class Capistrano::Rails::MdbsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Capistrano::Rails::Mdbs::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
