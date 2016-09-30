module SiteStation
  class ConstructionInfo < Base
    base_url 'api/v1/constructions'

    include Virtus.model
    attribute :id,                              Integer
    attribute :name,                            String
    attribute :site_name,                       String
    attribute :construction_joint_venture_name, String
    attribute :company_sub_classification_name, String
    attribute :started_date,                    Date
    attribute :ended_date,                      Date
    attribute :construction_date,               Date
    attribute :completion_date,                 Date
    attribute :total_area,                      Float
    attribute :prefecture_name,                 String
    attribute :address1,                        String
  end
end
