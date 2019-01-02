class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :cookbooks
  has_many :users, through: :cookbooks
end
