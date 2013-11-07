require 'ehcache'

module AhnCache
  class EhcacheStore < Store
    def write(key, value, options={})
      driver.put(key, value, mapped_options(options))
    end

    def read(key)
      item = driver.get(key)
      item.value if item
    end

    def fetch(key, options={}, &block)
      driver.acquire_write_lock_on_key(key)
      
      if !options[:force]
        item = driver.get(key)

        value = item.value if item
        value ||= block ? block.call : nil
      else
        value = block ? block.call : nil
      end

      driver.put(key, value, mapped_options(options))
      return value
    ensure
      driver.release_write_lock_on_key(key)
    end

    def flush
      driver.flush
    end

    def shutdown
      @cache_manager.shutdown
    end

    private
    def mapped_options(opts)
      options = {}
      opts[:ttl] ||= Adhearsion.config.cache.ttl
      options[:ttl] = opts[:ttl] if opts[:ttl]
      options[:if_absent] = !(opts[:force] || false)
      options
    end
    
    def connect_driver
      @cache_manager = Java::NetSfEhcache::CacheManager.new
      @cache = @cache_manager.cache("adhearsion")
      @cache
    end

    def driver
      @cache
    end
  end
end
