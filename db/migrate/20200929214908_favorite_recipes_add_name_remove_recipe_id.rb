class FavoriteRecipesAddNameRemoveRecipeId < ActiveRecord::Migration[5.0]
  def change
  
    remove_column :favorite_recipes, :recipe_id
    add_column :favorite_recipes, :name, :string
  
  end
end
