

require_relative '../../config/environment.rb'

class User < ActiveRecord::Base
  has_many :user_ingredients
  has_many :ingredients, through: :user_ingredients
  has_many :cookbook
  has_many :recipes, through: :cookbook

  #def self.new_user(name)
    #self.find_or_create_by(name: name)
  #end

end
