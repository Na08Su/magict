class ArticlesController < ApplicationController
	def index
		set_search
		@search_articles = @q.result.order(created_at: :desc)
		@move_article = Article.order(created_at: :asc).limit(5) # jqueryで左右に流れる
		render :layout => false

	end
	def show
		set_search
		@article = Article.find(params[:id])
		@articles = @q.result.order(created_at: :desc).limit(6) #　ここの表示ロジックは後で考える  
		render :layout => false
	end

	protected

	def set_search
		@q = Article.search(params[:q]) # articleでの共通headerで使うため
	end
end
