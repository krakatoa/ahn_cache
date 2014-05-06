module AhnCache
  class Store
    include Celluloid

    finalizer :shutdown

    def initialize
      connect_driver
    end

    def write(key, value)
      raise "Not implemented error"
    end

    def clear(key)
      raise "Not implemented error"
    end

    def read(key)
      raise "Not implemented error"
    end

    def flush
      raise "Not implemented error"
    end

    def shutdown
      raise "Not implemented error"
    end

  private
    def connect_driver
      raise "Not implemented error"
    end
  end
end
