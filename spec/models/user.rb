class User < ActiveRecord::Base
  include ::Portunus::Encryptable

  encrypted_fields :email, :firstname
end
