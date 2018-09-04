require 'sqlite3'

# Database wrapper that sets up helper methods for insertion, deletion and quering the database
class Database
  def initialize(database_name = 'main.db')
    @db = SQLite3::Database.open(database_name)
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
      latest_price = book.latest_price
      update(book, latest_price) if book.price != latest_price
    end
  end

  def update(book, latest_price)
    begin
      @db.execute('UPDATE books SET current_price=? WHERE title=?;', [latest_price, book.title])
    rescue SQLite3::Exception => exception
      puts "Exception #{exception} occurred"
   end
  end

  #currently id is hard coded and doesn't work properly
  def insert(book)
    begin
      @db.execute('INSERT INTO books(id, title, current_price, desired_price, url) VALUES(?,?,?,?,?);', [1, book.title, book.price, book.desired_price, book.url])
    rescue SQLite3::Exception => exception
      puts "Exception #{exception} occurred"
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
    rescue SQLite3::Exception => exception
      puts "Exception #{exception} occurred"
   end
  end
end
