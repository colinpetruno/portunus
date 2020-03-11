class User < ActiveRecord::Base
  include ::Portunus::Encryptable
end
