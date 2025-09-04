require 'redis'

url      = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/0')
password = ENV['REDIS_PASSWORD']

$redis = Redis.new(url: url, password: password) # rubocop:disable Style/GlobalVars
