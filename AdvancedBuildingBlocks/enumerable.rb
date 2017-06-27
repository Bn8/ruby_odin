module Enumerable
	def my_each
		return to_enum(:my_each) unless block_given?
		i=0
		a = self.to_a
		while i < a.size 
			yield a[i]
			i+=1
		end
	end

	def my_each_with_index
		return to_enum(:my_each_with_index) unless block_given?
		i=0
		a = self.to_a
		while i < a.size 
			yield a[i],i
			i+=1
		end
	end

	def my_select
		return to_enum(:my_select) unless block_given?
		a = []
		self.my_each do |x|
			a.push(x) if yield(x)
		end
		return a
	end

	def my_all?(&block)
		return self.my_all? {|tmp| tmp} unless block_given?
		self.my_each do |x|
			return false unless yield(x)
		end
		return true
	end

	def my_any?
		return self.my_any? {|tmp| tmp} unless block_given?
		self.my_each do |x|
			return true if yield(x)
		end
		return false
	end

	def my_none?
		return true unless block_given?
		self.my_each do |x|
			return false if yield(x)
		end
		return true
	end

	def my_count(num=nil)
		unless block_given?
			return self.size if num==nil
			return self.my_count {|item| item==num }
		end
		count=0
		self.my_each do |x|
			count += yield(x) ? 1 : 0 
		end
		return count
	end

	def my_map(proc=nil)
		return to_enum(:my_map) if (!block_given? and proc==nil)
		new_arr=[]
		self.my_each do |x|
			new_arr.push(proc ? proc.call(x) : yield(x))
		end
		return new_arr
	end

	def my_inject(initial_value = nil, &block)
		return self.to_a[1..-1].my_inject(self.first, &block) if initial_value == nil
		final_result = initial_value
		self.my_each do |x|
			if block_given?
				final_result = yield(final_result, x)
			end
		end
		return final_result
	end
end

def multiply_els(arr)
	return arr.my_inject { |total, z| total * z } 
end

arr=[5,2,8]

#arr.my_each {|x| print x}

#arr.my_each_with_index {|x,i| print "(#{x},#{i})" } 
#p [1,2,3,4,5].my_select { |num|  num.even?  } # [2,4]
#print %w[ant bear cat].my_all? { |word| word.length >= 3 }, %w[ant bear cat].my_all? { |word| word.length >= 4 }, [nil, true, 99].my_all? # true, false, false
#puts
#print %w[ant bear cat].my_any? { |word| word.length >= 3 }, %w[ant bear cat].my_any? { |word| word.length >= 4 }, [nil, true, 99].my_any? # true, true, true

'''
puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
puts [].my_none?                                           #=> true
puts [nil].my_none?                                        #=> true
puts [nil, false].my_none?                                 #=> true
'''
#puts arr.my_each
'''
ary = [1, 2, 4, 2]
puts ary.my_count               #=> 4
puts ary.my_count(2)            #=> 2
puts ary.my_count{ |x| x%2==0 } #=> 3
'''


p (1..4).my_map { |i| i*i }      #=> [1, 4, 9, 16]
p (1..4).my_map (Proc.new {|x| x*x})      #=> [1, 4, 9, 16]

p (1..4).my_map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]



'''
puts multiply_els([2,4,5])
puts (5..10).inject(:+)

'''
