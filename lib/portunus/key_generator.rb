module Portunus
  class KeyGenerator
    def self.generate
      AES.key
    end
  end
end
