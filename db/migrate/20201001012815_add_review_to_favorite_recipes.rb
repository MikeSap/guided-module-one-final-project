class AddReviewToFavoriteRecipes < ActiveRecord::Migration[5.0]
  def change
  
    add_column :favorite_recipes, :review, :string
  
  end
end
