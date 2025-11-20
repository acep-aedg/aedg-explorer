# REDIS-BASED FEATURE FLAG MANAGEMENT
class FeatureFlag
  PREFIX = 'feature_flag:'.freeze

  class << self
    def enabled?(name)
      REDIS_POOL.with do |redis|
        redis.get(key(name)) == 'enabled'
      end
    end

    def enable!(name)
      REDIS_POOL.with do |redis|
        redis.set(key(name), 'enabled')
      end
    end

    def disable!(name)
      REDIS_POOL.with do |redis|
        redis.set(key(name), 'disabled')
      end
    end

    def delete(name)
      REDIS_POOL.with do |redis|
        redis.del(key(name))
      end
    end

    def list
      scan_all_flags
    end

    private

    def scan_all_flags
      flags = {}
      cursor = '0'

      REDIS_POOL.with do |redis|
        loop do
          cursor, keys = redis.scan(cursor, match: "#{PREFIX}*")

          keys.each do |k|
            name = k.delete_prefix(PREFIX)
            flags[name] = redis.get(k)
          end

          break if cursor == '0'
        end
      end

      flags
    end

    def key(name)
      "#{PREFIX}#{name}"
    end
  end
end
