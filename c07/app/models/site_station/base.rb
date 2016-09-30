module SiteStation
  class Base
    def to_data_attributes
      attributes.each_with_object({}) do |(key, val), hash|
        val = I18n.l(val) if val.is_a?(Date)
        hash[key] = val
      end
    end

    class << self
      attr_reader :request_url

      def base_url(url)
        @request_url = url
      end

      def api_client
        SiteStation::ApiClient.instance
      end

      def find(id)
        response = api_client.request(method: :get, request_url: "#{ request_url }/#{ id }")
        include?(Virtus::Model::Core) ? new(response) : response
      end

      def resources(params)
        params = (params || {}).reverse_merge!(page: 1, limit: Settings.per_page_api)
        response = api_client.request(method: :get, request_url: request_url, params: params) || {}
        response = response.with_indifferent_access
        response['results'] = response['results'].map { |r| new(r) } if include?(Virtus::Model::Core)
        response
      end
    end
  end
end
