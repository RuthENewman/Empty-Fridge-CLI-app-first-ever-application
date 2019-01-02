require_relative 'config/environment.rb'
require_relative 'get_users.rb'
require_relative 'get_users_ingredients.rb'

def run_programme
  GetUsers.get_user_name
  GetUsersIngredients.save_user_ingredients
  = User.ingredients  
end

run_programme
