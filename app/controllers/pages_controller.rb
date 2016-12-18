class PagesController < ApplicationController
  def about
  end

  def landing
    render :layout => false
    # @users = User.all

    # @user = User.new
    # puts @user.nil?
  end
end
