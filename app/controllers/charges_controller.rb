class ChargesController < ApplicationController

  before_action :authenticate_user!
  def free
    project = Project.find(params[:project_id])
    current_user.subscriptions.create(project: project)

    redirect_to project
  end

  def pay
    project = Project.find(params[:project_id]) # projectに課金システムを作るため

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => project.price, # project.rbにメソッド定義済み
      :description => project.name,
      :currency    => 'jpy'
    )

    if charge
      current_user.subscriptions.create(project: project) # chageが正常に行われた場合、閲覧権利を付与する
      redirect_to project
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to project
  end

end
