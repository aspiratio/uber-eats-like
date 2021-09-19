module Api
	module V1
		class LineFoodsController < ApplicationController
			# create, replaceアクションの実行前にset_foodを実行する
			before_action :set_food, only: %i[create, replace]
			
			def index
				line_foods = LineFood.active
				if line_foods.exists?
					render json: {
						line_food_ids: line_foods.map {|line_food| line_food.id},
						# １つの仮注文につき１つの店舗という仕様のため、line_foods[1]もline_foods[2]もrestaurantは同じ。どれでもいいので[0]で取得している
						restaurant: line_foods[0].restaurant,
						count: line_foods.sum {|line_food| line_food[:count] },
						amount: line_food.sum {|line_food| line_food.total_amount},
					}, status: :ok
				else
					render json: {}, status: :no_content
				end
			end
			
			def create
				# 他店舗での仮注文がすでにある場合に、その例外パターンを検知して最初にリターンで処理を終えるようにする
				if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
					return render json: {
						# すでに作成されている他店舗のname
						existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
						# このリクエストで作成しようとした新店舗のname
						new_restaurant: Food.find(params[:food_id]).restaurant.name,
					}, status: :not_acceptable
				end
				
				# 以下は上記の例外パターンでなかったときに実行される処理
				set_line_food(@ordered_food)
				
				if @line_food.save
					render json: {
						line_food: @line_food
					}, status: :created
				else
					render json: {}, status: :internal_server_error
				end
			end
			
			def replace
				LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
					line_food.update_attribute(:active, false)
				end
				
				set_line_food(@ordered_food)
				
				if @line_food.save
					render json: {
						line_food: @line_food
					}, status: :created
				else
					render json: {}, status: :internal_server_error
				end
			end
				
			private
			
			def set_food
				@ordered_food = Food.find(params[:food_id])
			end
			
			# 新しくline_foodを生成する場合。すでに同じfoodに関するline_foodが存在する場合で処理が異なる
			def set_line_food(ordered_food)
				if ordered_food.line_food.present?
					@line_food = ordered_food.line_food
					@line_food.attributes = {
						count: ordered_food.line_food.count + params[:count],
						active: true
					}
				else
					@line_food = ordered_food.build_line_food(
						count: params[:count],
						restaurant: ordered_food.restaurant,
						active: true
					)
				end
			end
		end
	end
end

