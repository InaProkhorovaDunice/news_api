# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models #added this line to extend devise model
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :articles
end