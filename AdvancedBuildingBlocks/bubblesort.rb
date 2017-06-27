
def bubble_sort_by(arr)
	a = arr.clone # the sorted array will be here
	
	(0..a.size-1).each do |i|
		(0..a.size-1-(i+1)).each do |j|
			cmp = yield(a[j], a[j+1])
			if cmp > 0 then
				a[j], a[j+1] = a[j+1], a[j]
			end
		end
	end

	return a
end

def bubblesort(arr)
	return  bubble_sort_by(arr) {  |left,right| left-right }
end


p bubblesort([4,1,8,4,6,7,3])

p (bubble_sort_by(["hi","hello","hey"]) do |left,right|
	left.length - right.length
end)
