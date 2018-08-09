require 'sqlite3'

# Provides helper methods for setting up the database
class DatabaseSetup
  def initialize; end

  def create_db(name)
    db = SQLite3::Database.new(name)
    add_schema(db)
  end

  def add_schema(db)
    db.execute <<-SQL
            create table if not exists books(
            id int,
            title text,
            current_price float,
            desired_price float,
            url varchar(120)
          );
    SQL
  end

  def create_db_in_memory
    db = SQLite3::Database.new(':memory')
    add_schema(db)
  end

  def teardown
    db = SQLite3::Database.new(':memory')
    db.execute <<-SQL
            drop table books;
    SQL
  end
end
