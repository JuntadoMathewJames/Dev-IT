class User < ApplicationRecord
    has_secure_password

    validates :username, :password_digest, :status, presence: true
    validates :username, uniqueness:true
    validates :password_digest, length:{minimum: 8}
end
