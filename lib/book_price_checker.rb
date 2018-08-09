require_relative 'book'
require_relative '../db'
require 'json'

# Checks Amazon book prices against a user specified price
class BookPriceChecker
  def initialize(file_name, database = Database.new)
    @file_name = file_name
    @books = []
    @db = database
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

  def unwatch(title)
    remove_book(title)
  end

  def watched_books
    { books: @books.map { |book| { title: book.title, cheap?: book.cheap_enough? } } }
  end

  private

  def add_book(book)
    book.scrape_details
    @db.insert(book)
    load_books
  end

  def remove_book(title)
    @db.delete_title(title)
    load_books
  end

  def load_books
    @books = @db.books
    File.open(@file_name, 'w') { |file| file.write(watched_books.to_json) }
  end
end
