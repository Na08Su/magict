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
  :storage        => :s3,
  :bucket         => ENV['S3_BUCKET_NAME'],
  :s3_region      => ENV['AWS_REGION'],
  :s3_host_name   => ENV['s3-ap-northeast-1.amazonaws.com'],
  :s3_credentials => {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
}
  
end
