require "minitest/autorun"
require_relative 'statement_after'

require 'json'
require 'pry'


class TestMeme < Minitest::Test
  def test_that_kitty_can_eat
    plays = JSON.parse(File.read('plays.json'))
    invoices = JSON.parse(File.read('invoices.json'))

    expected = "Statement for BigCo\n  Hamlet: $650.00 (55 seats)\n  As You Like It: $580.00 (35 seats)\n  Othello: $500.00 (40 seats)\nAmount owed is $1730.00\nYou earned 47 credits\n"
    assert_equal expected, statement(invoices.first, plays)
  end
end
