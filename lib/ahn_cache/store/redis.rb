require 'redis'

module AhnCache
  class RedisStore < Store
    def write(key, value, options={})
      ttl = options[:ttl] || nil
      value = Marshal.dump(value)
      if ttl
        @cache.setex key, ttl, value
      else
        @cache.set key, value
      end
    end

    def read(key)
      value = @cache.get(key)
      value ? Marshal.load(value) : nil rescue nil
    end

    def exists?(key)
      @cache.exists key
    end

    def fetch(key, block, options={})
      value = read key
      if !value || options[:force]
        value = block ? block.call : nil rescue nil
        write(key, value, mapped_options(options)) if value
      end
      value
    end

    def flush
      # WARNING: Use carefully.
      # Redis doesn't currently support namespace flushes, or wildcard key deletion.
      # This will flush the current Redis database in its entirety, not just the namespace.
      @cache_manager.flushdb
    end

    def shutdown
      # TODO: redis-rb doesn't connect until needed. Not required to shutdown.
    end

    private
    def mapped_options(options={})
      options[:ttl] ||= Adhearsion.config.cache.ttl
      options[:force] ||= false
      options
    end

    def connect_driver
      @cache_manager = Redis.new(:url => Adhearsion.config.cache.url)
      @cache = Redis::Namespace.new(:adhearsion, :redis => @cache_manager)
      @cache
    end

    def driver
      @cache
    end
  end
end
