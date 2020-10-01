require_relative "../lib/api_communicator.rb"
require_relative '../config/environment'
require_relative "../app/recipe_app.rb"
$idiot_sandwich = "../lib/sounds/idiot_sandwich.mp3"


app = RecipeApp.new
app.run 
