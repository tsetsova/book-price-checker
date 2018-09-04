require 'optparse'
require 'json'
require_relative 'book_price_checker'
require_relative '../db'

options = {}

OptionParser.new do |parser|
  parser.banner = 'Usage: main.rb [options]'

  parser.on('-h', '--help', 'Show this message') do |list|
    puts parser
  end

  parser.on('-u', '--url URL', 'The Amazon URL of the Kindle book you want to add to your watch list') do |url|
    options[:url] = url
  end

  parser.on('-p', '--price PRICE', Float, 'The price the book needs to reach for you to be alerted') do |price|
    options[:price] = price
  end

  parser.on('-l', '--list', 'List the status of your saved books') do |list|
    options[:list] = list
  end

  parser.on('-r', '--refresh', 'Refresh the status of your saved books') do |refresh|
    options[:refresh] = refresh
  end
end.parse!

if (options[:url] && options[:price])
  begin
    db = Database.new
    db.setup
    book_price_watcher = BookPriceChecker.new(db)

    book = book_price_watcher.watch(options[:url], options[:price])
    puts "#{ book.title } has been added."
    puts "The current price is #{ book.current_price }"
    puts "The desired price has been set to #{ options[:price]}"
  ensure
    db.close
  end
elsif (options[:list])
  db = Database.new
  db.setup
  book_price_watcher = BookPriceChecker.new(db)

  puts book_price_watcher.watched_books.to_json
elsif (options[:refresh])
  db = Database.new
  db.setup
  book_price_watcher = BookPriceChecker.new(db)

  book_price_watcher.refresh_books
  puts book_price_watcher.watched_books.to_json
else
  puts "Please add a url AND a desired price. Use -h or --help for more information."
end
