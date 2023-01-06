FirebaseIdToken.configure do |config|
  config.redis = if Rails.env.production? || Rails.env.staging?
                  Redis.new(cluster: [ENV.fetch('REDIS_URL').to_s])
                else
                  Redis.new
                end
  config.project_ids = [Rails.application.credentials.firebase[:project_id]]
end
