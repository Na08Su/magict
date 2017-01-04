Rails.application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier

  config.serve_static_assets = true
  # config.serve_static_files 
  config.assets.compile = true  
  config.assets.digest = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  # paperclipの設定

  config.paperclip_defaults = {
  storage: :s3,
  s3_region: ENV['ap-northeast-1'],
  s3_credentials: {
    bucket: ENV['s3user-magict2017'],
    access_key_id: ENV['AKIAJMCD5ZVNRFCUSQ3A'],
    secret_access_key: ENV['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']
  }
}
  
end
