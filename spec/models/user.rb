class User < ActiveRecord::Base
  include ::Portunus::Encryptable

  encrypted_fields :email, :firstname, login_count: { type: :integer }

  validates :lastname, presence: true
  validates :firstname, { length: { minimum: 3 } }
end
