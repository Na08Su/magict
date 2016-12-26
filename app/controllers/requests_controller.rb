class RequestsController < ApplicationController
	before_action :authenticate_user!
	before_action :find_request, only: [:show, :edit, :update, :destroy]

	def index
		@requests = Request.all.order(created_at: :asc) # 最近のリクエスト順
	end

	def show
	end

	def new
		@request = current_user.requests.build # Request.new
	end

	def create
		@request = current_user.requests.build(request_params) # この書き方めちゃ便利ww
		if @request.save
			redirect_to requests_path, :flash => { :success => 'リクエストありがとう!正常に投稿されました!' }
		else
			flash.now[:error] = 'リクエスト投稿に失敗しました....'
			render 'new'
		end
	end

	def edit
	end

	def update
		if @request.update(request_params)
			redirect_to @request, :flash => { :success => 'リクエスト内容を更新しました!' }
		else
			flash.now[:error] = '更新失敗!'
			render 'show'
		end
	end

	def destroy
		if @request.destroy
			redirect_to root_url, :flash => { :success => 'リクエストを削除しました!' }
		else
			flash.now[:error] = '削除に失敗しました!'
			render 'show'
		end
	end


	private

	def find_request
		@request = Request.find(params[:id])
	end

	def request_params
		params.require(:request).permit(:title, :description)
	end
end
