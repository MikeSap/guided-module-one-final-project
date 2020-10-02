require 'json'
require 'rest-client'
require 'openssl'
require 'pry'

def get_recipes_from_api(selection)
    ingredients = selection.join(",+")
    url1 = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=dcb46d79bce84f0a809b82152f537d1e&ingredients="
    url2 = ingredients.to_s
    url3 = "&number=5"
    url = url1+url2+url3
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    response = response_hash.each_with_object({}){|item, hash| hash[item["title"].to_s] = item["id"].to_i}
    response
end 
def recipe_instructions(recipe_id)
    url1 = "https://api.spoonacular.com/recipes/"
    url2 = recipe_id.to_s
    url3 = "/information?apiKey=dcb46d79bce84f0a809b82152f537d1e"
    url = url1+url2+url3
    response_line = RestClient.get(url)
    response_api= JSON.parse(response_line)
    response = response_api["sourceUrl"]
    response
end 

