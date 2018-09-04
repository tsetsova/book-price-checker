require_relative 'scraper'

# Stores Amazon Kindle book details
class Book
  attr_accessor :desired_price, :url, :title, :price #need to get rid of title and price as they are defined twice...

  def initialize(url, desired_price, scraper = Scraper.new)
    @title = ''
    @price = 0
    @desired_price = desired_price
    @url = url
    @scraper = scraper
  end

  def self.from_db(_id, title, price, desired_price, url)
    book = new(url, desired_price)
    book.title = title
    book.price = price
    book.desired_price = desired_price
    book
  end

  def title
    @title == '' ? @title = @scraper.scrape_title(@url) : @title
  end

  def price
    @price.zero? ? @price = @scraper.scrape_price(@url) : @price
  end

  def scrape_details
    @title = @scraper.scrape_title(url)
    @price = @scraper.scrape_price(url)
  end

  def cheap_enough?
    @price <= @desired_price
  end

  def latest_price
    @scraper.scrape_price(@url)
  end

  def to_map
    {
      title: title,
      cheap?: cheap_enough?,
      price: price,
      desired_price: desired_price
    }
  end
end
