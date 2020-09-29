class User < ActiveRecord::Base
    
    has_many :pantry_ingredients
    has_many :ingredients, through: :pantry_ingredients
    has_many :favorite_recipes
    has_many :recipes, through: :favorite_recipes  
    
    
    def self.find_user(user_name)
        User.all.find_by(name: user_name)
      end

    def pantry
        pantry_ids = self.pantry_ingredients.map {|ing|  ing.ingredient_id}
        pantry = Ingredient.all.select {|ing| pantry_ids.include?(ing.id)}
        pantry_items = pantry.map {|ing| ing.name}
    end


    def create_pantry_ingredients
        ing = ingredient_prompt
        found_ingredient = nil
       Ingredient.all.each do |i| if i.name == ing     
         found_ingredient = i
       end
     end
       if found_ingredient == nil
         Ingredient.create(name: ing)
         PantryIngredient.create(ingredient_id: Ingredient.last.id, user_id: self.id)
       else
         PantryIngredient.create(ingredient_id: found_ingredient.id, user_id: self.id)
       end  
     end

end