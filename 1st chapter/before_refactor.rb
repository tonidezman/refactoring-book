require 'json'
require 'pry'

plays = JSON.parse(File.read('plays.json'))
invoices = JSON.parse(File.read('invoices.json'))

def statement(invoice, plays)
  totalAmount = 0
  volumeCredits = 0
  result = "Statement for #{invoice['customer']}\n"

  invoice['performances'].each do |perf|
    play = plays[perf['playID']]
    thisAmount = 0

    case play['type']
    when 'tragedy'
      thisAmount = 40_000
      thisAmount += 1_000 * (perf['audience'] - 30) if perf['audience'] > 30
    when 'comedy'
      thisAmount = 30_000
      if perf['audience'] > 20
        thisAmount += 10_000 + 500 * (perf['audience'] - 20)
      end
      thisAmount += 300 * perf['audience']
    else
      raise "unknown type: #{play['type']}"
    end

    # add volume credits
    volumeCredits += [perf['audience'] - 30, 0].max
    # add extra credit for every ten comedy attendees
    volumeCredits += (perf['audience'] / 5.0).floor if 'comedy' == play['type']

    # print line for this order
    result +=
      "  #{play['name']}: #{(thisAmount / 100.0)} (#{perf['audience']} seats)\n"
    totalAmount += thisAmount
  end
  result += "Amount owed is #{(totalAmount / 100.0)}\n"
  result += "You earned #{volumeCredits} credits\n"
  result
end

puts statement(invoices.first, plays)
