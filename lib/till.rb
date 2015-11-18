require 'json'


class Till

	attr_reader :menu
	attr_accessor :order, :item_cost, :tax_cost, :total_cost, :customers, :change_due, :discounts, :item_list

	def initialize 
		@json_data = File.read('hipstercoffee.json')
		@parsed_data = JSON.parse(@json_data)
		@menu = @parsed_data[0]["prices"][0]
		@order = {}
		@item_cost = 0.00
		@tax_cost = 0.00
		@total_cost = 0.00
		@discounts = 0.00
		@customers = []
		@item_list = {}
	end

	def placeOrder(hash)
		
		self.customers = hash.keys
		self.customers.each do |name|
			self.order[name] = hash[name]
		end
		
		self.calculateCost

	end

	def calculateCost

		self.customers.each do |name|
			customer_order = self.order[name]
			customer_order.keys.each do |item|
				self.item_list[item] = customer_order[item]
				self.item_cost += self.menu[item] * customer_order[item]
			end
		end

		self.calculateDiscounts
		self.calculateTax

		p "Final item_cost"
		p self.item_cost
		p " "
		p "Final tax_cost"
		p self.tax_cost
		float_total = self.item_cost + self.tax_cost
		self.total_cost = float_total.round(2)
	end

	def calculateTax
		self.tax_cost = (self.item_cost * 0.0864)
		 # * 100).round / 100.0)
		p "This is the tax_cost"
		p self.tax_cost
	end

	def payBalance(payment)
		if self.total_cost >= payment
			self.total_cost -= payment
		else
			self.change_due = payment - self.total_cost
		end

	end

	def calculateDiscounts
		muffins = ["Blueberry Muffin", "Chocolate Chip Muffin", "Muffin Of The Day"]
		muffins.each do |item|
			if self.item_list.keys.include?(item)
				self.discounts += ((self.item_list[item] * self.menu[item]) * 0.10)
					# .round(2))
			end
		end
		if self.item_cost > 50
			self.discounts += (self.item_cost * 0.05)
			 # * 100).round / 100.0)
		end
		p "This is the discount amount"
		p self.discounts
		p "This is the item_cost before subtracting discounts"
		p self.item_cost
		self.item_cost -= self.discounts
		p "This is the item_cost after subtracting discounts"
		p self.item_cost
	end

end

