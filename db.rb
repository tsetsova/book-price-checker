require 'sqlite3'
require 'logger'

# Database wrapper that sets up helper methods for insertion, deletion and quering the database
class Database
  def initialize(database_name = 'main.db', logger = Logger.new('logfile.log','weekly'))
    @db = SQLite3::Database.open(database_name)
    @logger = logger
    @logger.level = Logger::INFO
  end

  def setup
    @db.execute <<-SQL
            create table if not exists books(
            id int,
            title text,
            current_price float,
            desired_price float,
            url varchar(120)
          );
    SQL
  end

  def close
    @db.close
  end

  def refresh
    books.each do |book|
      new_price = book.latest_price
      if book.price != new_price
        update(book, new_price)
      else
        @logger.info('No changes. Everything is up to date.')
    end
  end

  def update(book, new_price)
    begin
      @db.execute('UPDATE books SET current_price=? WHERE title=?;', [new_price, book.title])
      @logger.info("Updated: #{book.title} used to cost #{book.price}, now costs #{new_price}")
    rescue SQLite3::Exception => exception
      @logger.error("Exception #{exception} occurred")
   end
  end

  #currently id is hard coded and doesn't work properly
  def insert(book)
    begin
      @db.execute('INSERT INTO books(id, title, current_price, desired_price, url) VALUES(?,?,?,?,?);', [1, book.title, book.price, book.desired_price, book.url])
      @logger.info("Addition: #{book.title} has been added succesfully.")
    rescue SQLite3::Exception => exception
      @logger.error("Exception #{exception} occurred")
   end
  end

  #currently duplicates are not managed
  def books
    @db.execute('SELECT DISTINCT  * FROM books;').map do |book_data|
      Book.from_db(*book_data)
    end
  end

  def delete_title(title)
    begin
      @db.execute('DELETE FROM books WHERE title=?', [title])
      @logger.info("Deletion: #{book.title} has been removed succesfully.")
    rescue SQLite3::Exception => exception
      @logger.error("Exception #{exception} occurred")
   end
  end
end
