def format(money)
  "$#{sprintf('%.2f', money)}"
end

def amount_for(performance, play)
  case play['type']
  when 'tragedy'
    this_amount = 40_000
    this_amount += 1_000 * (performance['audience'] - 30) if performance['audience'] > 30
  when 'comedy'
    this_amount = 30_000
    if performance['audience'] > 20
      this_amount += 10_000 + 500 * (performance['audience'] - 20)
    end
    this_amount += 300 * performance['audience']
  else
    raise "unknown type: #{play['type']}"
  end
  this_amount
end

def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice['customer']}\n"

  invoice['performances'].each do |performance|
    play = plays[performance['playID']]

    # add volume credits
    volume_credits += [performance['audience'] - 30, 0].max
    # add extra credit for every ten comedy attendees
    volume_credits += (performance['audience'] / 5.0).floor if 'comedy' == play['type']

    # print line for this order
    result +=
      "  #{play['name']}: #{format(amount_for(performance, play) / 100.0)} (#{
        performance['audience']
      } seats)\n"
    total_amount += amount_for(performance, play)
  end
  result += "Amount owed is #{format(total_amount / 100.0)}\n"
  result += "You earned #{volume_credits} credits\n"
  result
end
