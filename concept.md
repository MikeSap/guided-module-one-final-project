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
has_many :recipe_ingredients
Has many ingredients through recipe ing
has_many :favorite_recipes
has many users through fav

Ingredient: name, 
has many pantry ingredients
has many users through Pantry_ingredient
has many ingredients
has many recipes through recipe ingredient

Favorite Recipes: user_id, recipe_id
belongs to user

Recipe_Ingredient, recipe_id, ingredient_id
belongs to :recipe
belongs to :ingredient

Pantry_Ingredient, ingredient_id, user_id
belongs to :ingredient
belongs to :user


Workflow:
1. welcome message (can we store username and use for all these methods?)
2. what do you want to do today? (a.view pantry b. view favorites c. search recipes)
    2a. list pantry items. ablity to add and remove
    2b. list favorite recipes(select and view recipe), can remove
    2c. list user pantry items and select 3 for search
3. back to home (2)


When recipes are added to favorites, they are stored as a recipe, and the containing ingredients are stored as recipe_ingredients. 

Maybe remove the recipe class all together and tie recipe_ingredients to favorite recipes


@user
print recipe from favorite recipe menu
add review and edit reviews


