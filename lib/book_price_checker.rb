require_relative 'book'
require_relative '../db'
require 'json'

# Checks Amazon book prices against a user specified price
class BookPriceChecker
  def initialize(database = Database.new)
    @books = []
    @db = database
  end

  def current_price(url)
    @books.find { |book| book.url == url }.price
  end

  def watch(url, desired_price)
    @db.insert(Book.new(url, desired_price))
  end

  def unwatch(title)
    remove_book(title)
  end

  def watched_books
    Hash[:books, load_books.map(&:to_map)]
  end

  def refresh_books
    @db.refresh
    load_books
  end

  private

  def remove_book(title)
    @db.delete_title(title)
  end

  def load_books
    @books = @db.books
  end
end
