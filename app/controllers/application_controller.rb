class ApplicationController < ActionController::API
	before_action :fake_load
	# ローカルでローディングを意図的に遅くするための処理（1秒だけプログラムの実行を止める）
	def fake_load
		sleep(1)
	end
end
