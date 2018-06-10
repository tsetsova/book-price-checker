require 'faraday'
require 'nokogiri'

class BookPriceChecker

  def initialize(file_name)
    @file_name = file_name
    @book_details = {}
    @desired_price = 1.99
  end
 
  def watch(url)
    add_to_url_list(url)
  end

  def get_title(response_body)
    scrape_for_title(Nokogiri::HTML(response_body))
  end

  def get_price(response_body)
    scrape_for_price(Nokogiri::HTML(response_body)).to_f
  end

  def list_urls
    urls = []
    File.foreach(@file_name){ |url| urls << url.strip}
    urls
  end

  def get_book_details
    populate_book_details
  end 
 
  def check_book_cheapness
    @book_details.each do |title, current_price| 
      cheap_enough?(title, current_price)
    end
  end

  private

  def populate_book_details
    urls = list_urls
    bodies = urls.map {|url| Faraday.get(url).body}
    Hash[ *bodies.collect{ |body| [get_title(body), get_price(body)] }.flatten ] 
  end

  def add_to_url_list(url)
    File.open(@file_name, 'a') { |file| file.write(url + "\n")}
  end

  def scrape_for_title(html) 
    match = html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(html)
    match = /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)
    match[1]
  end

  def cheap_enough?(title, current_price)
    if (current_price <= @desired_price)
      puts "Yay! #{title} is only #{current_price}!!"
    else
      puts ":( ... #{title} is not cheap enough"
    end 
  end
end
