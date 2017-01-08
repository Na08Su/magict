class ArticlesController < ApplicationController
	def index

		@articles = Article.all.order(created_at: :desc)
		render :layout => false


	end
	def show

		@article = Article.find(params[:id])
		@articles = Article.order(created_at: :desc).limit(6) #　ここの表示ロジックは後で考える  
		render :layout => false
	end
end
