require 'faraday'
require 'nokogiri'

class BookPriceChecker

  def initialize
    @url = read_url
    @current_price = get_price
    @desired_price = 1.99
  end
  
  def get_response_body
    Faraday.get(@url).body
  end

  def get_price
    scrape_for_price(Nokogiri::HTML(get_response_body)).to_f
  end

  def cheap_enough?
    @current_price <= @desired_price
  end

  private

  def read_url
    file = File.readlines('urls.txt').first.strip
  end 

  def scrape_for_price(html)
    match = /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)
    match[1]
  end
end

book_price_checker = BookPriceChecker.new

puts book_price_checker.get_price

puts book_price_checker.cheap_enough?
