module BusinessHelper
  def profit_divisions_for_select
    current_user.company.profit_divisions.map do |profit_division|
      [profit_division.name, profit_division.id]
    end
  end
end
