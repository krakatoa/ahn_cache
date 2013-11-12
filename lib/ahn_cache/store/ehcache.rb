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

    def exists?(key)
      driver.key_in_cache?(key)
    end

    def fetch(key, block, options={})
      transactional = exists?(key)
      driver.acquire_write_lock_on_key(key) if transactional
      
      if !options[:force]
        item = driver.get(key)

        value = item.value if item
        value ||= block ? block.call : nil rescue nil
      else
        value = block ? block.call : nil rescue nil
      end

      driver.put(key, value, mapped_options(options))
      return value
    ensure
      driver.release_write_lock_on_key(key) if transactional
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
