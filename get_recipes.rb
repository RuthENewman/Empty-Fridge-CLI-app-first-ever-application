require 'net/http'
require 'open-uri'
require 'unirest'

require_relative 'config/environment.rb'


class GetRecipes
  def self.obtain_recipe(i1, i2)
    response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=5&ranking=1&ingredients=#{i1}%2C#{i2}",
    headers:{
    "X-RapidAPI-Key" => "zg9YxzyhyGmshCEUn9o7xW7quDu9p1hy8Hpjsn2c6XXgmzXb1R"}
    recipes = response.body
  end

  def self.recipe_names(i1,i2)
    recipe_titles = []
    count = 0
    recipe_array = GetRecipes.obtain_recipe(i1,i2)
    recipe_array.each do |recipe_hash|
      recipe_hash.each do |key, value|
        if key == "title"
          count += 1
          recipe_titles << "#{count}. #{value}"
        end
      end
    end
    recipe_titles
  end


  def self.save_recipe(i1, i2)
    top_5 = GetRecipes.recipe_names(i1,i2)
    puts 'Save a recipe '
    user_input = gets.chomp
    Recipe.create(name:"#{user_input}")
  end
end






GetRecipes.recipe_names("chicken", "rice")
binding.pry
p 'eof'
