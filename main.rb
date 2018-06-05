require 'faraday'
require 'nokogiri'

class BookPriceChecker

  def initialize
    @url = get_url
    @book_title = get_title
    @current_price = get_price
    @desired_price = 1.99
  end
  
  def get_response_body
    Faraday.get(@url).body
  end

  def get_price
    scrape_for_price(Nokogiri::HTML(get_response_body)).to_f
  end

  def get_title
    scrape_for_title(Nokogiri::HTML(get_response_body))
  end
 
  def cheap_enough?
    if (@current_price <= @desired_price)
      puts "Yay! #{@book_title} is currently #{@current_price}"
    else
      puts "\"#{@book_title}\" is not cheap enough"
    end 
  end

  private

  def get_url
    File.readlines('urls.txt').first.strip
  end 

  def scrape_for_title(html) 
    match = html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(html)
    match = /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)
    match[1]
  end
end

book_price_checker = BookPriceChecker.new

puts book_price_checker.get_price

puts book_price_checker.cheap_enough?
