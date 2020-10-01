class RecipeApp
  attr_reader :user

  def run 
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
      selection = prompt.select("What would you like to do today?", (["View Pantry", "View Favorite Recipes", "Search Recipes", "Exit"]))
        if selection == "View Pantry"
          view_pantry
        elsif selection == "View Favorite Recipes"
          view_favorite_recipes
        elsif selection == "Search Recipes"
          search
        else

          ## add selection to view or edit recipe reviews 
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
        binding.pry 
      elsif selection == "Search for Recipes"
        search
      elsif selection == "Remove Ingredient"
        
        selection2 = rm_ingredient_prompt
        if selection2  == "Back to Home"
          home
        elsif selection2 ==  "Back to Pantry"
          view_pantry
        elsif @user.pantry_names.include?(selection2)
        ing_to_remove = @user.pantry_ingredients.find{|pantry_ingredient| pantry_ingredient.ingredient.name == selection2}
        PantryIngredient.destroy(ing_to_remove.id)
        puts "#{Ingredient.all.find_by_name(selection2).name} has been removed from your pantry"
        view_pantry 
        end
        
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
        rec_to_remove = @user.favorite_recipes.find_by_name(selection2).id
        removed_name = @user.favorite_recipes.find_by_name(selection2).name
        @user.favorite_recipes.destroy(rec_to_remove)      
        puts "#{removed_name} has been removed from your favorite recipes"
        home
          end
        elsif @user.fav_recipe_names.include?(selection)
        recipe_id =  @user.favorite_recipes.find {|rec| rec.name == selection}.recipe_id
        url = recipe_instructions(recipe_id)
        puts TTY::Link.link_to(selection, url)
        home
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
    recipe_names = recipes.map { |key,val| key.to_s.titleize}
    prompt = TTY::Prompt.new
    recipes_select = prompt.multi_select("What recipes would you like to add to your favorites?", (recipe_names))
      recipes_select.each do |rec| 
      FavoriteRecipe.find_or_create_by(name:rec, user_id: @user.id, recipe_id: recipes[rec])
      puts "You added #{rec} to your favorites!"
      end   
    home
  end


  def view_edit_reviews

  elsif selection == "Rate or Update Reviews"
    selection2 = review_recipe_prompt

    if selection2 == "Back to Home"
      home
    elsif selection2 == "Back to Favorite Recipes"
      view_favorite_recipes
    else
      puts "Type a review for #{selection2}"
      review = gets.chomp.strip.downcase
      reviewed_rec = @user.favorite_recipes.find{|rec| rec.name == selection2}
      reviewed_rec.review= review
      reviewed_rec.save
      view_favorite_recipes
    end
    # add edit reviews 
     # all favorite recipes 
       ## gets.chomp that edits the reviews
    # list fav recipes that have reviews
      # selected, it prints the reviews
    
  end 
end 



def ingredient_prompt
  prompt = TTY::Prompt.new
  prompt.ask("What ingredients do you have in your kitchen?")
end

def recipe_search_prompt
  prompt = TTY::Prompt.new
  selection = prompt.multi_select("What would you like to cook with?", (@user.pantry_names))
end

def rm_ingredient_prompt
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
  menu_prompt = @user.fav_recipe_names.push("Rate or Update Reviews", "Remove a Recipe", "Back to Home")
   prompt.select("Select a recipe to see more info, or return home", (menu_prompt))    
end


def remove_recipe_prompt
  prompt = TTY::Prompt.new
  menu_prompt = @user.fav_recipe_names.push("Back to Favorite Recipes", "Back to Home")
  prompt.select("Select a recipe to remove", (menu_prompt))
end


def review_recipe_prompt
  prompt = TTY::Prompt.new
  menu_prompt = @user.fav_recipe_names.push("Back to Favorite Recipes", "Back to Home")
  prompt.seleqact("Select a recipe to review", (menu_prompt))
end

 
