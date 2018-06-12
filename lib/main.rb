require 'optparse'
require_relative 'book_price_checker'

options = {}

OptionParser.new do |parser|
  parser.banner = 'Usage: main.rb [options]'

  parser.on('-h', '--help', 'Show this message') do ||
    puts parser
  end

  parser.on('-u', '--url URL', 'The Amazon URL of the Kindle book you want to add to your watch list') do |url|
    options[:url] = url
  end

  parser.on('-p', '--price PRICE', Float, 'The price the book needs to reach for you to be alerted') do |price|
    options[:price] = price
  end

  parser.on('-l', '--list', 'List the status of the currently saved books') do |list|
    options[:list] = list
  end
end.parse!

book_price_watcher = BookPriceChecker.new('book_details.txt')

if (options[:url] && options[:price])
  book_price_watcher.watch(options[:url], options[:price])
  puts "#{ book_price_watcher.title(options[:url]) } has been added."
  puts "The current price is #{book_price_watcher.current_price(options[:url])}"
  puts "The desired price has been set to #{ options[:price]}"
elsif (options[:list])
  puts "#{book_price_watcher.cli_status}"
else 
  puts "Please add a url AND a desired price. Use -h or --help for more information."
end
