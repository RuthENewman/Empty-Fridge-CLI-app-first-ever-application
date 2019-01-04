require 'net/http'
require 'open-uri'
require 'unirest'
require_relative 'app/models/user.rb'

class Api
  attr_reader :current_user, :last_input, :new_ingredient, :ready, :spoonacular_ids, :instructions, :recipe_instructions_array, :api_recipe_instructions, :spoon_id

  def self.retrieve_instructions
    puts "Enter a recipe number to view instructions"
    user_input = gets.chomp
    @spoon_id = user_input
    Cli.get_instructions_for_api
    Cli.obtain_recipe_instructions
    Cli.instructions_array
  end

  def self.get_instructions_for_api
    @api_recipe_instructions = "#{@spoon_id}/information"

  end


def self.obtain_recipe_instructions
  response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + "#{@api_recipe_instructions}"
headers:{'X-RapidAPI-Key" => "zg9YxzyhyGmshCEUn9o7xW7quDu9p1hy8Hpjsn2c6XXgmzXb1R'}

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
Api.retrieve_instructions
