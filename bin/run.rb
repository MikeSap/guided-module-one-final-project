require_relative "../lib/api_communicator.rb"
require_relative '../config/environment'
require_relative "../app/recipe_app.rb"

app = RecipeApp.new
app.run 
