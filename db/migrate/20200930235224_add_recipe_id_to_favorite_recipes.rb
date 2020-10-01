class AddRecipeIdToFavoriteRecipes < ActiveRecord::Migration[5.0]
  def change

    add_column :favorite_recipes, :recipe_id, :integer

    
  end
end
