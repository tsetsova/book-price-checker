require 'faraday'
require 'nokogiri'

class BookPriceChecker

  def initialize
    @book_details = populate_book_details
    @desired_price = 1.99
  end
 
  def get_price(response_body)
    scrape_for_price(Nokogiri::HTML(response_body)).to_f
  end

  def get_title(response_body)
    scrape_for_title(Nokogiri::HTML(response_body))
  end

  def get_book_details
    puts @book_details
  end 
 
  def check_book_cheapness
    @book_details.each do |title, current_price| 
      cheap_enough?(title, current_price)
    end
  end

  def cheap_enough?(title, current_price)
    if (current_price <= @desired_price)
      puts "Yay! #{title} is only #{current_price}!!"
    else
      puts ":( ... \"#{title}\" is not cheap enough"
    end 
  end

  private

  def populate_book_details
    urls = [] 
    File.foreach('urls.txt'){ |url| urls << url.strip}
    bodies = urls.map {|url| Faraday.get(url).body}
    Hash[ *bodies.collect{ |body| [get_title(body), get_price(body)] }.flatten ] 
  end

  def scrape_for_title(html) 
    match = html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(html)
    match = /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)
    match[1]
  end
end
