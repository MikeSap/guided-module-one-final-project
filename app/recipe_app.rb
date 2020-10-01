class RecipeApp
  attr_reader :user

  def run 
    afplay $idiot_sandwich
    welcome
    login_or_signup
    home 
  end 

  private 

  def welcome  
    puts "Welcome to Recipalooza!!!"
  end

  def login_or_signup
    puts "Enter your name to sign up or login to Recipalooza!"
    name = gets.chomp.strip.downcase 
    @user = User.all.find_or_create_by(name: name.to_s.titleize)
  end 

  def home
    prompt = TTY::Prompt.new
      selection = prompt.select("What would you like to do today?", (["View Pantry", "View Favorite Recipes", "Search Recipes", "View or Edit Reviews", "Exit"]))
        if selection == "View Pantry"
          view_pantry
        elsif selection == "View Favorite Recipes"
          view_favorite_recipes
        elsif selection == "Search Recipes"
          search
        elsif selection == "View or Edit Reviews"
          view_edit_reviews
        else
          exit
        end 
  end
  

  def view_pantry
      selection = view_pantry_prompt      
      if selection == "Home"
        home
      elsif selection == "Add Item"
        @user.create_pantry_ingredients
        view_pantry
      elsif selection == "Search for Recipes"
        search
      elsif selection == "Remove Ingredient"
        remove_pantry_ingredient_menu
      else
        #show nutritional facts
        home
    end
  end

  def view_favorite_recipes
      selection = view_favorite_recipes_prompt
      if selection == "Back to Home"
        home
      elsif selection == "Remove a Recipe"        
        selection2 = remove_recipe_prompt
        if selection2 == "Back to Home"
          home
          elsif selection2 == "Back to Favorite Recipes"
            view_favorite_recipes
          else
            remove_favorite_recipe(selection2)        
            view_favorite_recipes
          end
        elsif @user.fav_recipe_names.include?(selection)
        open_recipe(selection)
        home
      end
  end
end


  def search
    @user.reload
    if @user.pantry.length < 3
      puts "You must have at least 3 items in your pantry before searching."
      view_pantry
    else
     selection = recipe_search_prompt
    end
    recipes = get_recipes_from_api(selection)
    recipes_select = search_result(recipes)
    add_favorite_recipes(recipes_select,recipes)
    view_favorite_recipes
  end


  def view_edit_reviews
    selection = view_edit_review_prompt
    if selection == "Update a Review" 
      selection2 = update_review_prompt
      add_update_review(selection2)
    elsif selection == "Add a Review"
      selection2 = add_review_prompt
        add_update_review(selection2)
    elsif selection == "Back to Home"
      home
    elsif selection == "Back to Favorite Recipes"
      view_favorite_recipes
    else 
      all_user_reviews = FavoriteRecipe.all.where(name: selection)
      review = all_user_reviews.each{|recipe| puts "'#{recipe.review}' reviewed by: #{User.find_by(id: recipe.user_id).name}"}
    end 
end 

def add_update_review(selection2)
  if selection2 == "Back to Home"
    home
  elsif selection2 == "Back to View or Edit Reviews"
    view_edit_reviews
  else
    get_save_review(selection2)
    view_edit_reviews
  end
end

def get_save_review(recipe_name)
  puts "Type a review for #{recipe_name}"
  review = gets.chomp.strip.downcase
  reviewed_rec = @user.favorite_recipes.find{|rec| rec.name == recipe_name}
  reviewed_rec.review= review
  reviewed_rec.save
end 


def ingredient_prompt
  prompt = TTY::Prompt.new
  prompt.ask("What ingredients do you have in your kitchen?")
end

def recipe_search_prompt
  prompt = TTY::Prompt.new
  selection = prompt.multi_select("What would you like to cook with?", (@user.pantry_names))
end

def rm_pantry_ingredient_prompt
  @user.reload
  menu_prompt = @user.pantry_names.push("Back to Pantry", "Back to Home")
  prompt = TTY::Prompt.new
  prompt.select("Select an ingredient to remove", (menu_prompt))
end

def view_pantry_prompt
  @user.reload
  prompt = TTY::Prompt.new
  menu_prompt = @user.pantry_names.push("Add Item","Search for Recipes", "Remove Ingredient", "Back to Home")
  prompt.select("Select an item to remove. You can also add new item, or return home", (menu_prompt))
end

def view_favorite_recipes_prompt
  @user.reload
  prompt = TTY::Prompt.new
  menu_prompt = @user.fav_recipe_names.push("Remove a Recipe", "Back to Home")
   prompt.select("Select a recipe to see more info, or return home", (menu_prompt))    
end

def remove_recipe_prompt
  @user.reload
  prompt = TTY::Prompt.new
  menu_prompt = @user.fav_recipe_names.push("Back to Favorite Recipes", "Back to Home")
  prompt.select("Select a recipe to remove", (menu_prompt))
end

def recipe_without_reviews 
  favorite_recipes = @user.favorite_recipes.reload
  rec = favorite_recipes.where(review: nil)
  rec.map{|rec|rec.name}
end 

def recipe_with_reviews 
 favorite_recipes = @user.favorite_recipes.reload
  rec = favorite_recipes.where.not(review: nil)
  rec.map{|rec|rec.name}
end

def view_edit_review_prompt
  prompt = TTY::Prompt.new
  menu_prompt = recipe_with_reviews.push("Update a Review", "Add a Review", "Back to Favorite Recipes", "Back to Home")
  prompt.select("Select a recipe to view, update a recipe, or add a review.", (menu_prompt))
end

def update_review_prompt
  prompt = TTY::Prompt.new
  menu_prompt = recipe_with_reviews.push("Back to View or Edit Reviews", "Back to Home")
  prompt.select("Select a recipe to update it's review", (menu_prompt))
end

def add_review_prompt
  prompt = TTY::Prompt.new
  menu_prompt = recipe_without_reviews.push("Back to View or Edit Reviews", "Back to Home")
  prompt.select("Select a recipe to review.", (menu_prompt))
end

def remove_pantry_ingredient_menu
  selection = rm_pantry_ingredient_prompt
  if selection  == "Back to Home"
    home
  elsif selection ==  "Back to Pantry"
    view_pantry
  elsif @user.pantry_names.include?(selection)
  remove_pantry_ingredient(selection)
  view_pantry
  end
end

def remove_pantry_ingredient(selection)
  @user.reload
  ing_to_remove = @user.pantry_ingredients.find{|pantry_ingredient| pantry_ingredient.ingredient.name == selection}
  PantryIngredient.destroy(ing_to_remove.id)
  puts "#{Ingredient.all.find_by_name(selection).name} has been removed from your pantry"
end
 
def remove_favorite_recipe(selection)
  @user.reload
  rec_to_remove = @user.favorite_recipes.find_by_name(selection).id
  removed_name = @user.favorite_recipes.find_by_name(selection).name
  @user.favorite_recipes.destroy(rec_to_remove)      
  puts "#{removed_name} has been removed from your favorite recipes"
end

def open_recipe(selection)
  @user.reload
  recipe_id =  @user.favorite_recipes.find {|rec| rec.name == selection}.recipe_id
        url = recipe_instructions(recipe_id)
        puts TTY::Link.link_to(selection, url)
end

def search_result(recipes)
  recipe_names = recipes.map { |key,val| key.to_s.titleize}
  prompt = TTY::Prompt.new
  recipes_select = prompt.multi_select("What recipes would you like to add to your favorites?", (recipe_names))
end

def add_favorite_recipes(recipes_select,recipes)
  recipes_select.each do |rec| 
    FavoriteRecipe.find_or_create_by(name:rec, user_id: @user.id, recipe_id: recipes[rec])
    puts "You added #{rec} to your favorites!"
    end   
end
