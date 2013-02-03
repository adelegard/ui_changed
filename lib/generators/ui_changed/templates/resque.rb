# config/initializers/resque.rb

Resque.redis = "localhost:6379"  # default localhost:6379
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

# mailer queue name
Resque::Mailer.default_queue_name = 'ui_changed_mailer'