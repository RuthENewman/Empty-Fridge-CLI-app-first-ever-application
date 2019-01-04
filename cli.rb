
require 'net/http'
require 'open-uri'
require 'unirest'
require_relative 'app/models/user.rb'
require 'colorize'


class Cli

attr_reader :current_user, :last_input, :new_ingredient, :ready, :spoonacular_ids, :instructions, :api_recipe_instructions, :spoon_id, :user_ingredients_array

  def self.welcome
    puts" _______  __   __  _______  _______  __   __    _______  ______    ___   ______   _______  _______ "
    puts"|       ||  |_|  ||       ||       ||  | |  |  |       ||    _ |  |   | |      | |       ||       |"
    puts"|    ___||       ||    _  ||_     _||  |_|  |  |    ___||   | ||  |   | |  _    ||    ___||    ___|"
    puts"|   |___ |       ||   |_| |  |   |  |       |  |   |___ |   |_||_ |   | | | |   ||   | __ |   |___ "
    puts"|    ___||       ||    ___|  |   |  |_     _|  |    ___||    __  ||   | | |_|   ||   ||  ||    ___|"
    puts"|   |___ | ||_|| ||   |      |   |    |   |    |   |    |   |  | ||   | |       ||   |_| ||   |___ "
    puts"|_______||_|   |_||___|      |___|    |___|    |___|    |___|  |_||___| |______| |_______||_______|"
    puts "-"*202
    puts "Welcome to Empty Fridge. Reduce waste by finding recipes based on the ingredients you already have."
    puts "-"*202
    puts "Enter your name:".yellow
    user_input = gets.chomp
    @current_user = User.find_or_create_by(:name => user_input)
    puts "Welcome #{@current_user.name}"
  end

  def self.ingredient
    puts""
    puts "Enter an ingredient".yellow
    user_input = gets.chomp
    @new_ingredient = Ingredient.find_or_create_by(:name => user_input)
    @current_user.ingredients << @new_ingredient
    puts "#{@new_ingredient.name} has been added to your list of ingredients."
  end

  def self.get_users_ingredients
    @user_ingredients_array = @current_user.ingredients.all.map { |x| x.name}.uniq
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
    counter = 1
    @recipe_titles = []
    @spoonacular_ids  = []
    @recipes.each do |recipe_hash|
      recipe_hash.each do |key, value|
        if key == "title"
          @spoonacular_ids << "#{recipe_hash["id"]}"
          @recipe_titles << "#{counter}. #{value}"
          counter += 1
        end
      end
    end
      puts @recipe_titles
  end

def self.get_instructions_for_api
  @api_recipe_instructions = "#{@spoon_id}/information"

end

  def self.obtain_recipe_instructions
    response = Unirest.get "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + "#{@api_recipe_instructions}",
 headers:{
   "X-RapidAPI-Key" => "zg9YxzyhyGmshCEUn9o7xW7quDu9p1hy8Hpjsn2c6XXgmzXb1R"}
 @instructions = response.body
end

  def self.instructions_array
    @instructions.each do |key, value|
        if key == "instructions"
          puts "-"*202
          puts value
          puts "-"*202
        end
  end

end

def self.save_recipe_to_cookbook
puts 'Enter recipe number to save to your cookbook'.yellow
user_input = gets.chomp
case user_input.to_i
  when 1
    recipe_name = @recipe_titles[0].slice(3, @recipe_titles[0].length - 1)
    spoonacular_id =
    recipe = Recipe.create(:name => "#{recipe_name}", :spoonacular_id => "#{@spoonacular_ids[0]}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 2
    recipe_name = @recipe_titles[1].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}", :spoonacular_id => "#{@spoonacular_ids[1]}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 3
    recipe_name = @recipe_titles[2].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}", :spoonacular_id => "#{@spoonacular_ids[2]}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 4
    recipe_name = @recipe_titles[3].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}", :spoonacular_id => "#{@spoonacular_ids[3]}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when 5
    recipe_name = @recipe_titles[4].slice(3, @recipe_titles[0].length - 1)
    recipe = Recipe.create(:name => "#{recipe_name}", :spoonacular_id => "#{@spoonacular_ids[4]}")
    @current_user.recipes << recipe
    puts "Recipe Saved"
  when "Q"
    Cli.menu
  end

end

def self.browse_recipes_in_cookbook
  saved_recipe_list = @current_user.recipes
  recipe_list = []
  saved_recipe_list.each do |recipe|
        recipe_list << "#{recipe.spoonacular_id} - #{recipe.name}"
      end
      puts "-"*202
    puts recipe_list.uniq
    puts "-"*202
  end


  def self.retrieve_instructions
    puts "Enter a recipe number to view instructions".yellow
    user_input = gets.chomp
    user_input_downcase = user_input.downcase
    @spoon_id = user_input_downcase
    Cli.get_instructions_for_api
    Cli.obtain_recipe_instructions
    Cli.instructions_array
  end


  def self.menu
    puts 'What would you like to do now?'.green
    puts '1. Enter or add an ingredient'.green
    puts '2. Search for new recipes from your ingredients'.green
    puts '3. Browse saved recipes in your cookbook'.green
    puts '4. View your current ingredients'.green
    puts '5. Delete an ingredient'.green
    puts '6. Exit the programme'.green
    Cli.loop
  end

  def self.delete_ingredient

    #puts Cli.view_ingredients
    Cli.view_ingredients
    puts "Enter name of ingredient you would like to delete".yellow
    user_input = gets.chomp
    @current_user.ingredients.where(name: "#{user_input}").destroy_all
  end

  def self.view_ingredients
    x =  @current_user.ingredients.all.map { |x| x.name}.uniq
    puts x
    # @user_ingredients_array = @current_user.ingredients
    #
    # ingredients_list = []
    # @user_ingredients_array.each do |ingredient|
    #     ingredients_list << "#{ingredient.name}"
    #     end
    #     puts "-"*202
    #   print ingredients_list.uniq.join(", ")
    #   puts""
    #   puts "-"*202

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
        puts "-"*202
        Cli.recipe_array
        puts "-"*202
        puts "Enter Q to return to menu"
        Cli.save_recipe_to_cookbook
        Cli.menu
        break
      when 3
        Cli.browse_recipes_in_cookbook
        Cli.retrieve_instructions
        Cli.menu
        break
      when 4
        Cli.view_ingredients
        Cli.menu
        break
      when 5
        Cli.delete_ingredient
        Cli.menu
        break
      when 6
        Cli.bye
        break
      else
        puts "Please enter valid menu option (1-6)".yellow
        Cli.menu
        break
      end
    end
  end

    def self.bye
      puts  "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░".red
      sleep(0.1)
      puts  "░░░▄▄▀▀▀▀▀▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░".red
      sleep(0.1)
      puts  "░░▄▀░░░░░░░▀▄░░░░░░░░░░░░░░░░░░░░░░░░░░".red
      sleep(0.1)
      puts  "░▄▀░░░▄▄░░░░▀▀▀▀▀▀▀▄▄▀▀▀▀▀▀▀▀▀▀▀▀▄▄░░░░".red
      sleep(0.1)
      puts  "░█░░░░██░░░░░░░░░░░░░░░░░░░░░░░░░░░▀▄░░".red
      sleep(0.1)
      puts  "░█░░░░██▄████▄░██▄░░░░▄██░▄████▄░░░░▀▄░".red
      sleep(0.1)
      puts  "░█░░░░██▀░░▀██▄░██▄░░██▀░██▀░▄██░░░░░█░".red
      sleep(0.1)
      puts  "░█░░░░███▄▄███▀░░░▀██▀░░░▀██▄▄▄██░░░░█░".red
      sleep(0.1)
      puts  "░▀▄░░░░▀▀▀▀▀▀░░░░░██▀░░░░░░▀▀▀▀▀░░░░░█░".red
      sleep(0.1)
      puts  "░░▀▄░░░░░░░░░░░░░██▀░░░▄▄░░░░░░░░░▄▄▀░░".red
      sleep(0.1)
      puts  "░░░░▀▀▀▀▀▀▀▀▀▄░░░▀▀░░░▄▀░▀▀▀▀▀▀▀▀▀░░░░░".red
      sleep(0.1)
      puts  "░░░░░░░░░░░░░▀▄░░░░░░▄▀░░░░░░░░░░░░░░░░".red
      sleep(0.1)
      puts  "░░░░░░░░░░░░░░░▀▀▀▀▀▀░░░░░░░░░░░░░░░░░░".red
      sleep(0.1)
      puts  "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░".red

    end

end
