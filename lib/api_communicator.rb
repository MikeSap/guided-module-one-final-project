require 'json'
require 'rest-client'
require 'openssl'
require 'pry'

def get_recipes_from_api(ingredients)
    ingredients = ingredients.join(",+")
    url1 = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=85995cd1d4df4f84a8119f108d266819&ingredients="
    url2 = ingredients
    url3 = "&number=5"
    url = url1+url2+url3
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    response = response_hash.map{|recipe|recipe["title"]}
    response
end 
