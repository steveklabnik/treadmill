require "treadmill/version"

$pointsz = Hash.new(0)

class Class
  method_blacklist = [:method_added, :===, :to_s, :send, :public_methods, :new]
  methods_to_redefine = public_methods.reject{|m| method_blacklist.include? m }

  methods_to_redefine.each do |m|
    new_name = "__lol_omg_#{m}"

    define_method m do |*args, &blk|
      __lol_omg_puts "#{m} was called with #{args}"
      $pointsz[m] += 1
      send(new_name, *args, &blk)
    end

    alias_method new_name, m
  end
end

class Module
  method_blacklist = [:method_added, :===, :to_s, :send, :public_methods]
  methods_to_redefine = public_methods.reject{|m| method_blacklist.include? m }

  methods_to_redefine.each do |m|
    new_name = "__lol_omg_#{m}"

    define_method m do |*args, &blk|
      __lol_omg_puts "#{m} was called with #{args}"
      $pointsz[m] += 1
      send(new_name, *args, &blk)
    end

    alias_method new_name, m
  end
end

module Kernel
  method_blacklist = BasicObject.public_methods
  methods_to_redefine = public_methods
    .reject{|m| method_blacklist.include? m }
    .reject{|m| m.to_s.start_with?("__lol_omg_") }
    

  methods_to_redefine.each do |m|
    new_name = "__lol_omg_#{m}"

    alias_method new_name, m

    define_method m do |*args, &blk|
      __lol_omg_puts "#{m} was called with #{args}"
      $pointsz[m] += 1
      send(new_name, *args, &blk)
    end
  end
end

module Treadmill
  class Lol
    def foo
    end
  end
end

Treadmill::Lol.new.foo

at_exit do
  __lol_omg_puts "SUMMARY: "
  __lol_omg_puts "method\t\tcalls"

  $pointsz.each do |k, v|
    __lol_omg_puts "#{k}\t\t#{v}"
  end
end
