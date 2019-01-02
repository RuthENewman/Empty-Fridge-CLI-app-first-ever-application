require_relative 'config/environment.rb'

class GetUsersIngredients

  def self.get_user_ingredients
    puts "Enter Ingredients"
    ingredients  = gets.chomp
    ingredients_array = ingredients.split(/[\s]+/)
    ingredients_array
  end

  def self.save_user_ingredients
    ingredients_array = GetUsersIngredients.get_user_ingredients
    ingredients_array.each do |i|
      Ingredient.create(name: "#{i}")
    end
  end
end


GetUsersIngredients.save_user_ingredients
