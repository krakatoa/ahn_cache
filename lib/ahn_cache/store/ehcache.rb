require 'ehcache'

module AhnCache
  class EhcacheStore < Store
    def write(key, value)
      driver.put(key, value)
    end

    def read(key)
      item = driver.get(key)
      item.value if item
    end

    private
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
