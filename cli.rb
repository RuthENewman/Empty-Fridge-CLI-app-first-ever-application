
require 'net/http'
require 'open-uri'
require 'unirest'
require_relative 'app/models/user.rb'


class Cli

attr_reader :current_user, :last_input, :new_ingredient, :ready

  def self.welcome
    puts "Welcome to Empty Fridge"
    puts "Enter your name:"
    user_input = gets.chomp
    @current_user = User.find_or_create_by(:name => user_input)
    puts "Welcome #{@current_user.name}"
  end

  def self.ingredient
    puts "Enter an ingredient"
    user_input = gets.chomp
    @new_ingredient = Ingredient.find_or_create_by(:name => user_input)
    @current_user.ingredients << @new_ingredient
    puts "#{@new_ingredient.name} has been added to your list of ingredients."
  end

  def self.get_users_ingredients
    @user_ingredients_array = @current_user.ingredients.all.map { |x| x.name}.uniq
    puts "#{@user_ingredients_array}"
  end

  def self.ingredients_for_api
    api_ingredients = @user_ingredients_array.map { |x| x + "%2C" }.join
    @ready = api_ingredients.chomp('%2C')
  end

  def self.obtain_recipe
    response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=5&ranking=1&ingredients=#{@ready}",
    headers:{
    "X-RapidAPI-Key" => "zg9YxzyhyGmshCEUn9o7xW7quDu9p1hy8Hpjsn2c6XXgmzXb1R"}
    @recipes = response.body
  end

  def self.recipe_array
    count = 0
    @recipe_titles = []
    @recipes.each do |recipe_hash|
      recipe_hash.each do |key, value|
        if key == "title"
          count += 1
          @recipe_titles << "#{count}. #{value}"
        end
      end
    end
      puts @recipe_titles
  end

def self.save_recipe_to_cookbook
puts 'Enter recipe number to save to your cookbook'
user_input = gets.chomp
case user_input.to_i
  when 1
    recipe_name = @recipe_titles[0].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 2
    recipe_name = @recipe_titles[1].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 3
    recipe_name = @recipe_titles[2].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 4
    recipe_name = @recipe_titles[3].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 5
    recipe_name = @recipe_titles[4].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  end

end

def self.browse_recipes_in_cookbook
  saved_recipe_list = @current_user.recipes
  recipe_list = []
  saved_recipe_list.each do |recipe|
        recipe_list << "#{recipe.name}"
      end
    puts recipe_list.uniq
end

  def self.menu
    puts 'What would you like to do now?'
    puts '1. Enter or add an ingredient'
    puts '2. Search for new recipes from your ingredients'
    puts '3. Browse saved recipes in your cookbook'
    puts '4. Exit the programme'
    Cli.loop
  end

  def self.loop
    user_input = gets.chomp
    while user_input != ""
    case user_input.to_i
      when 1
        Cli.ingredient
        Cli.menu
        break
      when 2
        Cli.get_users_ingredients
        Cli.ingredients_for_api
        Cli.obtain_recipe
        Cli.recipe_array
        Cli.save_recipe_to_cookbook
        Cli.menu
        break
      when 3
        Cli.browse_recipes_in_cookbook
        sleep(5)
        Cli.menu
        break
      when 4
        Cli.bye
        break
      end
    end
  end

    def self.bye
      puts  "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
      sleep(0.1)
      puts  "░░░▄▄▀▀▀▀▀▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
      sleep(0.1)
      puts  "░░▄▀░░░░░░░▀▄░░░░░░░░░░░░░░░░░░░░░░░░░░"
      sleep(0.1)
      puts  "░▄▀░░░▄▄░░░░▀▀▀▀▀▀▀▄▄▀▀▀▀▀▀▀▀▀▀▀▀▄▄░░░░"
      sleep(0.1)
      puts  "░█░░░░██░░░░░░░░░░░░░░░░░░░░░░░░░░░▀▄░░"
      sleep(0.1)
      puts  "░█░░░░██▄████▄░██▄░░░░▄██░▄████▄░░░░▀▄░"
      sleep(0.1)
      puts  "░█░░░░██▀░░▀██▄░██▄░░██▀░██▀░▄██░░░░░█░"
      sleep(0.1)
      puts  "░█░░░░███▄▄███▀░░░▀██▀░░░▀██▄▄▄██░░░░█░"
      sleep(0.1)
      puts  "░▀▄░░░░▀▀▀▀▀▀░░░░░██▀░░░░░░▀▀▀▀▀░░░░░█░"
      sleep(0.1)
      puts  "░░▀▄░░░░░░░░░░░░░██▀░░░▄▄░░░░░░░░░▄▄▀░░"
      sleep(0.1)
      puts  "░░░░▀▀▀▀▀▀▀▀▀▄░░░▀▀░░░▄▀░▀▀▀▀▀▀▀▀▀░░░░░"
      sleep(0.1)
      puts  "░░░░░░░░░░░░░▀▄░░░░░░▄▀░░░░░░░░░░░░░░░░"
      sleep(0.1)
      puts  "░░░░░░░░░░░░░░░▀▀▀▀▀▀░░░░░░░░░░░░░░░░░░"
      sleep(0.1)
      puts  "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
      
    end

end


Cli.welcome
Cli.menu
# Cli.ingredient
# Cli.get_users_ingredients
# Cli.ingredients_for_api
# Cli.obtain_recipe
# Cli.recipe_array
# Cli.save_recipe_to_cookbook
# Cli.browse_recipes_in_cookbook
