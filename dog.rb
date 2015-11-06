class Animal
  attr_accessor :name

  def initialize(n)
    @name = n
  end
end

module Mammal 
  def warmblooded?
    true
  end
end

module Hissable
  def hiss
    puts "Hssss!!Pfft!Pfft!"
  end
end

class Cat < Animal
  include Mammal, Hissable
  attr_accessor :breed
  def initialize(n, breed)
    super(n)
    @breed = breed
  end
end


kitty = Cat.new("kitty", "Persian")
puts kitty.name
puts kitty.breed
puts kitty.warmblooded?
puts kitty.hiss if kitty.respond_to?("hiss")
puts Cat.ancestors

