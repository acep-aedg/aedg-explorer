require 'connection_pool'
require 'redis'

url      = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/0')
password = ENV['REDIS_PASSWORD']

REDIS_POOL = ConnectionPool.new(size: Integer(ENV.fetch('RAILS_MAX_THREADS', 5)), timeout: 5) do
  Redis.new(url: url, password: password)
end
