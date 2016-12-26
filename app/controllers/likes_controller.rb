class LikesController < ApplicationController

  def like
    @request = Request.find(params[:request_id]) # like.js.erbでは「@request」が使われています。ビューファイルで@noteという変数を使うためにはアクション側で変数@noteを定義しなければなりませんでした。
    # 変数likeに、current_userとbuildを用いてlikeインスタンスを代入
    like = current_user.likes.build(request_id: @request.id )
    like.save
  end

  def unlike
    @request = Request.find(params[:request_id])
    like = current_user.likes.find_by(request_id: @request.id)
    like.destroy
  end
end
