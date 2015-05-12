class Factory	
	def self.new *args, &block
		Class.new do 
			args.each { |arg| attr_accessor arg }

			define_method :initialize do |*a| 
				a.each_with_index { |val, index| instance_variable_set("@#{args[index]}", val) }
		  	end

		  	@@args = args
		  	# подсмотрел этот метод у Dmiriy Khanitskiy (https://github.com/Khanitskiy/Factory/blob/master/factory.rb)
		  	# сам не понимал, как сделать.. 
		  	def [](i)
			  	if i.class == String || i.class == Symbol
		  	  		self.instance_variable_get("@#{i}")
		  	  	elsif i.class == Fixnum 
		  	  		raise "Wrong argument number. Try integer from 0 to #{@@args.count - 1}" if i >= @@args.count
		  	  		self.instance_variable_get("@#{@@args[i]}") if v = nil
		  	  	end
		  	end

		  	# TODO: доделать возможность задавать значения переменным через "объект[переменная] = значение"

			class_eval(&block) if block_given?
		end	
	end	
end


Customer = Factory.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
puts joe.name 
# => Joe Smith
puts joe['name'] 
# => Joe Smith
puts joe[:name] 
# => Joe Smith
puts joe[2] 
# => 12345
#puts joe[3] 
# => factory.rb:15:in `[]': Wrong argument number. Try integer from 0 to 2 (RuntimeError)
joe.name = "Joe2"
puts joe.name # => Joe2



#puts
Customer2 = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end
puts Customer2.new("Dave", "123 Main").greeting
# => Hello Dave!

Customer3 = Struct.new(:name, :address)
molly = Customer3.new("Molly", "123 Main")

puts molly.name 
molly.name = "Molly2"
puts molly.name
#=> Molly2
puts molly[0] 
#=> Molly2
molly[0] = "Molly3"
puts molly[0]
#=> Molly3

#joe[2] = "345" #=> не работает
#puts joe[:adress] #=> не работает


