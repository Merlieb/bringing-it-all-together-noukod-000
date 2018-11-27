class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed, id: nil)
    @id = id
    @name = name
    @breed = breed
  end

end
