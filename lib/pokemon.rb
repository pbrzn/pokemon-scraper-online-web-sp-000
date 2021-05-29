class Pokemon
  attr_accessor :name, :type
  attr_reader :id, :db

  def initialize (id: nil, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?);
    SQL
    db.execute(sql, name, type)
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon;")[0][0]
  end

  def self.new_from_db(row)
    pokemon = self.new(id: row[0], name: row[1], type: row[2], db: @db)
  end

  def self.find(id, db)
    sql = "SELECT * FROM pokemon WHERE id = ?;"
    db.execute(sql, id).map {|row| self.new_from_db(row)}.first
  end
end
