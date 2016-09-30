module Kaminari
  module ActionViewExtension
    def paginate(scope, options = {})
      options.reverse_merge!(current_page: scope.current_page, total_pages: scope.total_pages, per_page: scope.limit_value, remote: false, method: :get)
      paginator = Kaminari::Helpers::Paginator.new(self, options)
      paginator.to_s
    end
  end
end
