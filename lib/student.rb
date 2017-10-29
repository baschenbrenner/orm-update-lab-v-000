require_relative "../config/environment.rb"

class Student
attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @name=name
    @grade=grade
    @id=id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students
        (id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
        DROP TABLE students
      SQL
      DB[:conn].execute(sql)
    end

    def save
      current_database_number=DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      if self.id < current_database_number || self.id == current_database_number
        DB[:conn].execute("UDPATE students SET name = ?, grade = ? WHERE id = ?;",self.name, self.grade, self.id)
      else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?,?)",self.name, self.grade)
      @id=DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
