class User < ActiveRecord::Base
    
    has_many :pantry_ingredients
    has_many :ingredients, through: :pantry_ingredients
    has_many :favorite_recipes
    has_many :recipes, through: :favorite_recipes

    def create_user
        name = get_username
        user = nil
          User.all.each do |u| if u.name == name
            user = u
          end
        end
          if user == nil
          User.create(name: name)
          user = User.last 
          end
        end

    def self.find_user(user_name)
        User.all.find_by(name: user_name)
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