class User < ActiveRecord::Base

    has_many :ingredients, through::pantry_ingredients
    has_many :recipes, through: :favorite_recipes



end