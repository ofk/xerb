# frozen_string_literal: true

require 'test_helper'
require 'cgi'

class XERBTest < Minitest::Test
  def test_version
    refute { ::XERB::VERSION.nil? }
  end

  def test_result
    xerb = XERB.new('<b><%= text %></b>') { |s| CGI.escapeHTML(s) }
    text = '<&>'
    assert text
    assert { xerb.result(binding) == '<b>&lt;&amp;&gt;</b>' }
  end
end
