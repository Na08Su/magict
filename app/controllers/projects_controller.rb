class ProjectsController < ApplicationController
  before_action :authenticate_user! , only: [:list]

  def index
    @projects = Project.all
    # puts 'でバッググッグググググg'
    # puts User.find(session[:user_id])
  end

  def show
    @project = Project.find(params[:id])
    @tasks   = @project.tasks.order(:tag)

    @joined = false # 初期値

    if !current_user.nil? && !current_user.projects.nil?
      @joined = current_user.projects.include?(@project)
    end
    @users = @project.users.order('created_at desc').first(10)

    @review = Review.new
    @reviews = @project.reviews
    @hasReview = @reviews.find_by(user_id: current_user.id) if current_user
  end

  def list
    if !current_user.nil?
      @projects = current_user.projects
    end
  end
end
