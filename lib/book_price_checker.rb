require 'faraday'
require 'nokogiri'

# Checks Amazon book prices against a user specified price
class BookPriceChecker
  attr_reader :book_details

  def initialize(file_name)
    @file_name = file_name
    @book_details = {}
  end

  def watch(url, desired_price)
    add_book(url, desired_price)
  end

  def cheap_enough?(title)
    @book_details[title][:current_price] <= @book_details[title][:desired_price]
  end

  private

  def get_title(response_body)
    scrape_for_title(Nokogiri::HTML(response_body))
  end

  def get_price(response_body)
    scrape_for_price(Nokogiri::HTML(response_body)).to_f
  end

  def scrape_for_title(html)
    html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(html)
    /£(\d\.\d+)/.match(html.at_css('tr.kindle-price td.a-color-price').text)[1]
  end

  def add_book(url, desired_price)
    response_body = Faraday.get(url).body
    title = get_title(response_body)
    current_price = get_price(response_body)
    @book_details.store(title, current_price: current_price,
                               desired_price: desired_price,
                               url: url)
  end

  def check_book_cheapness
    @book_details.each do |title, current_price|
      book_cheapness(title, current_price)
    end
  end

  def book_cheapness(title, current_price)
    if cheap_enough?(title)
      puts "Yay! #{title} is only #{current_price}!!"
    else
      puts ":( ... #{title} is not cheap enough"
    end
  end
end
