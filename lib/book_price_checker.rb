require_relative 'book'
require 'json'

# Checks Amazon book prices against a user specified price
class BookPriceChecker
  def initialize(file_name)
    @file_name = file_name
    @books = []
  end

  def title(url)
    @books.find { |book| book.url == url }.title
  end

  def current_price(url)
    @books.find { |book| book.url == url }.current_price
  end

  def watch(url, desired_price)
    add_book(Book.new(url, desired_price))
  end

  def status
    Hash[*@books.collect { |b| [b.title, { cheap?: b.cheap_enough? }] }.flatten]
  end

  def cli_status
    JSON.parse(File.readlines(@file_name).first.strip)
  end

  private

  def add_book(book)
    book.scrape_details
    @books << book
    File.open(@file_name, 'a') { |file| file.write(status.to_json) }
  end
end
