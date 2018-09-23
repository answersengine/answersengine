class HelloFail
  def initialize
    @hi = "Hello"
  end

  def say
    raise "fail from Hello class"
    @hi
  end
end