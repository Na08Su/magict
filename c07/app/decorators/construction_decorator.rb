module ConstructionDecorator
  def attributes_for_modal
    {
      site_name: site.name,
      name: name,
      enactment_location: "#{ site.main_site.prefecture.name }#{ site.main_site.address1 }",
      construction_date: site.construction_date.present? ? I18n.l(site.construction_date) : nil,
      completion_date: site.completion_date.present? ? I18n.l(site.completion_date) : nil,
      started_date: started_date.present? ? I18n.l(started_date) : nil,
      ended_date: ended_date.present? ? I18n.l(ended_date) : nil
    }
  end
end
