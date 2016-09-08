class User < ApplicationRecord
  belongs_to :squad, optional: true
  has_and_belongs_to_many :sprints

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
