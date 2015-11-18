require 'till.rb'

describe Till do
	
	subject(:till) { described_class.new }

	it 'knows how much items cost' do
		expect(till.menu["Cafe Latte"]).to be(4.75)
	end

	it 'can take orders' do
		till.placeOrder({"Alex"=>{"Cafe Latte"=>2}})
		expect(till.order["Alex"]["Cafe Latte"]).to eq 2
	end

	it 'calculates cost before taxes' do
		till.placeOrder({"Alex"=>{"Cafe Latte"=>1}})
		expect(till.item_cost).to eq 4.75
	end

	it 'calculates cost in taxes' do
		till.placeOrder({"Alex"=>{"Cafe Latte"=>1}})
		expect(till.tax_cost.round(2)).to eq 0.41
	end

	it 'calculates total cost' do
		till.placeOrder({"Alex"=>{"Cafe Latte"=>1}})
		expect(till.total_cost).to eq 5.16
	end

	it 'knows which customer ordered an item' do
		till.placeOrder("Alex"=>{"Cafe Latte"=>1})
		expect(till.order["Alex"]).to eq({"Cafe Latte"=>1})
	end

	it 'can accept payment for an item' do
		till.placeOrder("Alex"=>{"Cafe Latte"=>1})
		till.payBalance(5.16)
		expect(till.total_cost).to eq 0
	end

	it 'calculates correct change' do
		till.placeOrder("Alex"=>{"Cafe Latte"=>1})
		till.payBalance(10)
		expect(till.change_due).to eq 4.84
	end

	it 'calculates a 5% discount on orders over $50' do
		till.placeOrder("Alex"=>{"Cafe Latte"=>11})
		expect(till.total_cost).to eq 53.93
	end

	it 'calculates a 10% discount on blueberry muffins' do
		till.placeOrder("Alex"=>{"Blueberry Muffin"=>1})
		expect(till.total_cost).to eq 3.96
	end

	it 'calculates a 10% discount on chocolate chip muffins' do
		till.placeOrder("Alex"=>{"Chocolate Chip Muffin"=>1})
		expect(till.total_cost).to eq 3.96
	end

	it 'calculates a 10% discount on the Muffin Of The Day' do
		till.placeOrder("Alex"=>{"Muffin Of The Day"=>1})
		expect(till.total_cost).to eq 4.45
	end
end