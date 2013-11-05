module AhnCache
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded

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

    #
    init :ahn_cache do
      logger.warn "AhnCache has been loaded"

      store_klass(:ehcache).supervise_as(:cache)
    end

    # Basic configuration for the plugin
    #
    config :ahn_cache do
      # greeting "Hello", :desc => "What to use to greet users"
    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :ahn_cache do
        desc "Prints the PluginTemplate information"
        task :info do
          STDOUT.puts "AhnCache plugin v. #{VERSION}"
        end
      end
    end

  end
end
