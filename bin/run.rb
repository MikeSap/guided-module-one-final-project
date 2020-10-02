require_relative "../lib/api_communicator.rb"
require_relative '../config/environment'
require_relative "../app/recipe_app.rb"
$idiot_sandwich = "../lib/sounds/idiot_sandwich.mp3"
require_relative "../lib/beet.rb"

# $idiot_sandwich = Sound.new("lib/sounds/idiot_sandwich_clip.mp3")

app = RecipeApp.new
# $idiot_sandwich.play
app.run 

