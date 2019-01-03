require 'net/http'
require 'open-uri'
require 'unirest'
require_relative 'app/models/user.rb'

class Api
  attr_reader :current_user, :last_input, :new_ingredient, :ready, :spoonacular_ids, :instructions, :recipe_instructions_array, :api_recipe_instructions


def self.obtain_recipe_instructions
  response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/1046717/information",
headers:{
 "X-RapidAPI-Key" => "zg9YxzyhyGmshCEUn9o7xW7quDu9p1hy8Hpjsn2c6XXgmzXb1R"}
@instructions = response.body
end

def self.instructions_array
  @recipe_instructions_array = []
  @instructions.each do |key, value|
      if key == "instructions"
        @recipe_instructions_array << "#{value}"

      end

  end
    puts @recipe_instructions_array
end

end
Api.obtain_recipe_instructions
Api.instructions_array
