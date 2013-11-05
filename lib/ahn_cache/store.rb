module AhnCache
  class Store
    include Celluloid

    def initialize
      connect_driver
    end

    def write(key, value)
      raise "Not implemented error"
    end

    def read(key)
      raise "Not implemented error"
    end
  end
end
