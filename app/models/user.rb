class User < ActiveRecord::Base
  has_many :user_ingredients
  has_many :ingredients, through: :user_ingredients
  has_many :cookbook
  has_many :recipes, through: :cookbook

end
