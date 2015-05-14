require "./rg_factory/version"

module RgFactory
	class Factory	
		def self.new *args, &block
			Class.new do 
				args.each { |arg| attr_accessor arg }

				define_method :initialize do |*a| 
					a.each_with_index { |val, index| instance_variable_set("@#{args[index]}", val) }
			  	end

			  	@@args = args
			  	
			  	def [] (var)
				  	if var.class == String || var.class == Symbol
			  	  		self.instance_variable_get("@#{var}")
			  	  	elsif var.class == Fixnum 
			  	  		raise "Wrong argument number. Try integer from 0 to #{@@args.count - 1}" if var >= @@args.count
			  	  		self.instance_variable_get("@#{@@args[var]}")
			  	  	else 
			  	  		wrong_obj_error
			  	  	end
			  	end

			  	def []= (var, val)
				  	if var.class == String || var.class == Symbol
			  	  		self.instance_variable_set("@#{var}", val)
			  	  	elsif var.class == Fixnum 
			  	  		self.instance_variable_set("@#{@@args[var]}", val)
			  	  	else 
			  	  		wrong_obj_error
			  	  	end
			  	end

			  	def wrong_obj_error
			  		raise "Wrong object type in []. Try String, Symbol or Fixnum"
			  	end

				class_eval(&block) if block_given?
			end	
		end	
	end
end

=begin TESTING
	Customer = RgFactory::Factory.new(:name, :address, :zip)
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


	Customer2 = RgFactory::Factory.new(:name, :address) do
	  def greeting
	    "Hello #{name}!"
	  end
	end
	puts Customer2.new("Dave", "123 Main").greeting
	# => Hello Dave!

	joe.name = "Joe2"
	puts joe.name # => Joe2

	puts joe[:address] # => 123 Maple, Anytown NC
	joe[1] = "35, Veselaya str" 
	puts joe[:address] #=> 35, Veselaya str
	joe["address"] = "1-st String-setted str" 
	puts joe[:address] #=> 35, 1-st String-setted str

	joe[[]] = "test with wrong object" 
	#=> rg_factory.rb:37:in `wrong_obj_error': Wrong object type in []. Try String, Symb
	#=> ol or Fixnum (RuntimeError)
    #=>    from rg_factory.rb:32:in `[]='
    #=>    from rg_factory.rb:78:in `<main>'
=end