class EmailAuthentication < ApplicationRecord
  devise :database_authenticatable, :invitable, :lockable, :recoverable,
         :rememberable, :timeoutable, :trackable, :validatable

  has_one :user_authentication, as: :authenticatable
  has_one :user, through: :user_authentication
end
