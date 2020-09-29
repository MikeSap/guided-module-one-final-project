class Recipe < ActiveRecord::Base

    has_many :ingredients, through: :recipe_ingredients
    has_many :users, through: :favorite_recipes


end