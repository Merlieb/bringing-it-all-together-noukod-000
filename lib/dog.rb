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
      sql = <<-SQL
      UPDATE dogs SET name = ?, breed = ? WHERE id = ?;
               SQL

      DB[:conn].execute sql, self.name, self.breed, self.id
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

  def self.find_by_id id
    sql = <<-SQL
        SELECT * FROM dogs WHERE id = ? LIMIT 1
      SQL
    result = DB[:conn].execute(sql,id).flatten
    self.new_from_db(result)
  end

  def self.new_from_db(row)
  params = {id: row[0], name: row[1],breed: row[2]}
  new_dog = self.new(params)
  new_dog
end

def self.find_or_create_by(name:, breed:)
  sql = <<-SQL
        SELECT * FROM dogs WHERE name = ? and breed = ?
      SQL
  results = DB[:conn].execute(sql,name,breed).flatten
  if !results[0].nil?
    self.new_from_db(results)
  else
    self.create(name:name, breed:breed)
  end
end

  def self.find_by_name(name)
  sql = <<-SQL
        SELECT * FROM dogs WHERE name = ? LIMIT 1
      SQL
  results = DB[:conn].execute(sql,name).flatten
  self.new_from_db(results)
  end
end
