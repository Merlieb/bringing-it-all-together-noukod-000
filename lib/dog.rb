class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
                                     id INTEGER PRIMARY KEY,
                                     name TEXT,
                                     breed TEXT
                                   )
              SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = "DROP TABLE IF EXISTS dogs"
      DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.id, self.name, self.breed)
  end

  def save
      if self.id
        self.update
      else
        DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES(?, ?)", self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        self
      end
  end

  def self.create(name:, breed:)
   dog = Dog.new(name: name, breed: breed)
   dog.save
   dog
  end

  def self.find_by_id(result)#id)
  #  sql = "SELECT * FROM dogs WHERE id = ?"
  #  result = DB[:conn].execute(sql, id)[0]
  #  Dog.new(result[0], result[1], result[2])
  end
end
