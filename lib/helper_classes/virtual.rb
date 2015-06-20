class VirtualMethodCalledError < RuntimeError
  attr :name
  def initialize(name)
    super("Virtual function '#{name}' called")
    @name = name
  end
end

class Module
  def virtual(*methods)
    methods.each do |m|
      define_method(m) {
        raise VirtualMethodCalledError, m
      }
    end
  end
end
