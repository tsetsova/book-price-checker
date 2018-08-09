require 'sqlite3'

# Database wrapper that sets up helper methods for insertion, deletion and quering the database
class Database
  def initialize(database = 'main.db')
    @db = SQLite3::Database.open(database)
  end

  def insert(book)
    @db.execute('INSERT INTO books(id, title, current_price, desired_price, url) VALUES(?,?,?,?,?)', [1, book.title, book.current_price, book.desired_price, book.url])
  end

  def books
    @db.execute('select distinct  * from books').map do |book_data|
      Book.from_db(*book_data)
    end
  end

  def delete_title(title)
    @db.execute('delete from books where title=?', [title])
  end
end
