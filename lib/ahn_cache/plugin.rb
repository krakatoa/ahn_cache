module AhnCache
  class Plugin < Adhearsion::Plugin

    BACKENDS = [:ehcache]

    class << self
      def store_klass(backend)
        if BACKENDS.include?(backend)
          require File.join(File.dirname(__FILE__), "store", backend.to_s)
          AhnCache.const_get("#{backend.capitalize}Store")
        else
          AhnCache::Store
        end
      end
    end

    config :cache do
      config = YAML::load_file(File.join(Dir.getwd, "config/cache.yml")) rescue {}
      cache_config = config[Adhearsion.config.platform.environment.to_s] rescue nil

      if not cache_config
        $stdout.puts "Ahn-Cache config file is missing."
      else
        backend (cache_config["backend"] || "ehcache").to_sym
        ttl (cache_config["ttl"] || "unlimited")
      end
    end

    init :ahn_cache do
      logger.warn "AhnCache has been loaded"

      store_klass(Adhearsion.config.cache.backend).supervise_as(:cache)
    end

  end
end
