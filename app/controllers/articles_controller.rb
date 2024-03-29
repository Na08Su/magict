class ArticlesController < ApplicationController
	def index
		set_search
		@search_articles = @q.result.order(created_at: :desc)
		@move_article    = Article.order(created_at: :asc).limit(4) # jqueryで左右に流れる
		@right_article   = Article.second if Article.second
		@pick_up         = Article.order("RANDOM()").limit(3)

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

# コントローラの中で処理を切り替えるには、下記のようにします。

# if request.smart_phone?
#   # スマートフォン特有の処理
# else
#   # PC 特有の処理
# end
