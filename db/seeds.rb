User.create(name:"Mike")
User.create(name:"Barbara")

Ingredient.create(name:"Broccoli")
Ingredient.create(name:"Brown Rice")
Ingredient.create(name:"Chicken")
Ingredient.create(name:"Spinach")
Ingredient.create(name:"Cheese")
Ingredient.create(name:"Onions")
Ingredient.create(name:"Potato")

Recipe.create(name:"Chicken and Broccoli")
Recipe.create(name:"Brown Rice and Broccoli")

RecipeIngredient.create(ingredient_id:1,recipe_id:1)
RecipeIngredient.create(ingredient_id:1,recipe_id:2)
RecipeIngredient.create(ingredient_id:3,recipe_id:1)
RecipeIngredient.create(ingredient_id:2,recipe_id:2)

PantryIngredient.create(user_id:1, ingredient_id:1)
PantryIngredient.create(user_id:2, ingredient_id:1)
PantryIngredient.create(user_id:1, ingredient_id:2)
PantryIngredient.create(user_id:2, ingredient_id:3)

FavoriteRecipe.create(user_id:1, recipe_id:2)
FavoriteRecipe.create(user_id:2, recipe_id:1)
