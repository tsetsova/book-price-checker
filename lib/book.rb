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
  end

  def self.from_db(_id, title, current_price, desired_price, url)
    book = new(url, desired_price)
    book.title = title
    book.current_price = current_price
    book.desired_price = desired_price
    book
  end

  def scrape_details
    response_body = Faraday.get(@url).body
    @title = scrape_for_title(response_body)
    @current_price = scrape_for_price(response_body)
  end

  def cheap_enough?
    @current_price <= @desired_price
  end

  def to_map
    {
      title: title, 
      cheap?: cheap_enough?,
      price: current_price,
      desired_price: desired_price
    }
  end

  protected

  def scrape_for_title(response_body)
    html = Nokogiri::HTML(response_body)
    html.at_css('span#ebooksProductTitle').text
  end

  def scrape_for_price(response_body)
    selector = 'tr.kindle-price td.a-color-price'
    html = Nokogiri::HTML(response_body)
    /£(\d+\.\d+)/.match(html.at_css(selector).children[0].to_xml(encoding: "UTF-8").strip)[1].to_f
  end
end
