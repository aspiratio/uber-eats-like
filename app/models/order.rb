class Order < ApplicationRecord
	has_many :line_foods
	
	validates :total_price, numericality: {greater_than: 0}
	
	# ここではLineFoodデータの更新と、Orderデータの保存を処理している。これらの処理をトランザクションの中で行うようにすることで、この２つの処理のいずれかが失敗した場合に全ての処理をなかったことにするように配慮。
	def save_with_update_line_foods!(line_foods)
		ApplicationRecord::Base.tracsaction do
			line_foods.each do |line_food|
				line_food.update_attributes!(active: false, order: self)
			end
			self.save!
		end
	end
end
