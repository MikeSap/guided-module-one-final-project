class RemoveRecipeAndRecipeIngredientTable < ActiveRecord::Migration[5.0]
  def change

    drop_table :recipes
    drop_table :recipe_ingredients

  end
end
