class User < ActiveRecord::Base
    
    has_many :pantry_ingredients
    has_many :ingredients, through: :pantry_ingredients
    has_many :favorite_recipes
    
    
    def self.find_user(user_name)
        User.all.find_by(name: user_name)
      end

    def pantry
      self.pantry_ingredients.map {|pantry_ingredient| pantry_ingredient.ingredient}      
    end

    def pantry_names
      pantry.map {|ing| ing.name}
    end

    def fav_recipe_names
      self.favorite_recipes.map {|fav| fav.name}
    end

    def fav_recipe_id
      self.favorite_recipes.map {|fav| fav.recipe_id}
    end


    def create_pantry_ingredients
      ing = ingredient_prompt.strip.downcase
     found_ingredient = Ingredient.find_or_create_by(name: ing.to_s.titleize)  
       PantryIngredient.find_or_create_by(ingredient_id: found_ingredient.id, user_id: self.id)       
    end

end