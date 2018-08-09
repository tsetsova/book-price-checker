require 'faraday'
require 'nokogiri'

# Stores Amazon Kindle book details
class Book
  attr_accessor :title, :current_price, :desired_price, :url

  def initialize(url, desired_price)
    @title = ''
    @current_price = 0
    @desired_price = desired_price
    @url = url
    @book_details = {}
  end

  def self.from_db(_id, title, current_price, desired_price, url)
    book = new(url, desired_price)
    book.title = title
    book.current_price = current_price
    book.desired_price = desired_price
    book
  end

  def details
    scrape_details
    @book_details
  end

  def scrape_details
    response_body = Faraday.get(@url).body
    @title = scrape_for_title(response_body)
    @current_price = scrape_for_price(response_body)
    @book_details = { title: @title,
                      current_price: @current_price,
                      desired_price: @desired_price,
                      url: @url }
  end

  def cheap_enough?
    scrape_details
    @book_details[:current_price] <= @book_details[:desired_price]
  end

  protected

  def scrape_for_title(response_body)
    html = Nokogiri::HTML(response_body)
    html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(response_body)
    selector = 'tr.kindle-price td.a-color-price'
    html = Nokogiri::HTML(response_body)
    /£(\d\.\d+)/.match(html.at_css(selector).text)[1].to_f
  end
end
