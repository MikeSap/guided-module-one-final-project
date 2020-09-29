class CreateUsersIngredientsRecipesFavoriteRecipes < ActiveRecord::Migration[5.2]
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

    create_table :favorite_recipes do |t|
      t.integer :user_id
      t.integer :recipe_id
    end

    create_table :recipe_ingredients do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
    end

    create_table :pantry_ingredients do |t|
      t.integer :ingredient_id
      t.integer :user_id
    end

  end


end
