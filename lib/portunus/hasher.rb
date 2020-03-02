module Portunus
  class Hasher
    def self.for(input)
      return nil if input.blank?

      Digest::SHA2.new(512).hexdigest(input)
    end
  end
end
