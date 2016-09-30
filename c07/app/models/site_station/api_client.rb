module SiteStation
  class ApiClient
    include Singleton

    def request(method:, request_url:, params: {})
      conn = Faraday.new(url: ENV['SITE_STATION_API_URL']) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  :net_http
      end

      response = conn.send(method) do |req|
        req.url request_url
        req.params = params
      end

      parse(response.body)
    end

    private

    def parse(object)
      JSON.parse(object)
    rescue => e
      # TODO: もっとわかりやすいメッセージに変える
      Rails.logger.error("[API] #{ e.backtrace.join("\n") }")
      nil
    end
  end
end
