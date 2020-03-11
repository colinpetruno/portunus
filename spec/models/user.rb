class User < ActiveRecord::Base
  include ::Portunus::Encryptable

  encrypted_fields :email, :firstname

  validates :lastname, presence: true
end
