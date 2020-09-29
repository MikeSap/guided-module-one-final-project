Recipe App

User stories: 
1. User should be able to: login(icebox)
2. User should be able to: store favorite recipes
3. User should be able to: search based on ingredients in pantry
4. User should be able to: return recipes based on ingredients on hand
5. User should be able to: store local ingredients in their pantry
6. App should: remove ingredient from user's pantry when recipe is selected
7. User should be able to: access list of current pantry stock
8. App should: warn user when inventory items are low (icebox)
9. App should: be able to output nutritional data for a recipe(icebox)

Classes:

User: name
Has many ingredients
has many recipes through fav


Recipe: name
Has many ingredients
has many users through fav

Ingredient: name, 
has many users through Pantry_ingredient -->
has many recipes through recipe ingredient

Favorite Recipes: user_id, recipe_id
belongs to user
belongs to recipe

<!-- Recipe_Ingredient, recipe_id, ingredient_id
belongs to :recipe
belongs to :ingredient

Pantry_Ingredient, ingredient_id, user_id
belongs to :ingredient
belongs to :user