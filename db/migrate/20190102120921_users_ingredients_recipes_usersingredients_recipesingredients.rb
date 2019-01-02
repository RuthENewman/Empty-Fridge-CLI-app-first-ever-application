class UsersIngredientsRecipesUsersingredientsRecipesingredients < ActiveRecord::Migration[5.0]

  def change
    create_table :users do |t|
      t.string :name
    end
    create_table :ingredients do |t|
      t.string :name
    end

    create_table :recipes do |t|
      t.string :name
    end

    create_table :user_ingredients do |t|
      t.integer :user_id
      t.integer :ingredient_id
    end

    create_table :recipe_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
    end

    create_table :cookbooks do |t|
      t.integer :user_id
      t.integer :recipe_id
    end
  end
end
