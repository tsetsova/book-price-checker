require 'faraday'
require 'nokogiri'

class BookPriceChecker

  def initialize
    @url = read_url
  end
  
  def get_body
    response = Faraday.get(@url)
    response.body
  end

  def get_price
    scrape_for_price(Nokogiri::HTML(get_body))
  end

  #set desired price

  #compare_price with stored price


  def read_url
    file = File.readlines('urls.txt').first.strip
  end 

  private 

  def scrape_for_price(html)
    match = /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)
    match[1]
  end
end

book_price_checker = BookPriceChecker.new

puts book_price_checker.read_url

puts book_price_checker.get_price
