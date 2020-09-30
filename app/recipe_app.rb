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
    name = gets.chomp
    @user = User.all.find{|u|u.name == name}
     if @user == nil 
      @user = User.create(name: name) 
     end 
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
          exit
        end
  end
  

  def view_pantry
      @user.reload
      prompt = TTY::Prompt.new
      menu_prompt = @user.pantry_names.push("Add Item", "Remove Ingredient", "Home")
      selection = prompt.select("Select an item to remove. You can also add new item, or return home", (menu_prompt))
      if selection == "Home"
        home
      elsif selection == "Add Item"
        @user.create_pantry_ingredients 
        view_pantry
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
    @user.reload
    prompt = TTY::Prompt.new
      selection = prompt.select("Select a recipe to see more info, or return home") do |menu|
        @user.favorite_recipes.each {|rec| menu.choice rec.name}
        menu.choice "Home"
        menu.choice "Remove a recipe"
      end    
      if selection == "Home"
        home
      elsif selection == "Remove a recipe"
        prompt = TTY::Prompt.new
        selection = prompt.select("Select a recipe to remove") do |menu|
        @user.favorite_recipes.each {|rec| menu.choice rec.name}
        end
        rec_to_remove = @user.favorite_recipes.find_by_name(selection).id
        removed_name = @user.favorite_recipes.find_by_name(selection).name
        @user.favorite_recipes.destroy(rec_to_remove)      
        puts "#{removed_name} has been removed from your favorite recipes"
        home
      else
        #send to another page with recipe info (open browser?)
        home
      end
  end

  def search
    @user.reload
    if @user.pantry.length < 3
      puts "You must have at least 3 items in your pantry before searching."
      view_pantry
    else
      prompt = TTY::Prompt.new
      selection = prompt.multi_select("What would you like to cook with?", (@user.pantry_names))
    end
    recipes = get_recipes_from_api(selection)
    prompt = TTY::Prompt.new
      recipes_select = prompt.multi_select("What recipe would you like to add to your favorites?", (recipes))
      recipes_select.each do
      |rec| fav =  FavoriteRecipe.create(name:rec, user_id: @user.id)
      puts "You added #{rec} to your favorites!"
      end   
    home
  end

end 

def ingredient_prompt
  prompt = TTY::Prompt.new
  prompt.ask("What ingredients do you have in your kitchen?")
end

def rm_ingredient_prompt
  @user.reload
  menu_prompt = @user.pantry_names.push("Back to Home", "Back to Pantry")
  prompt = TTY::Prompt.new
        selection = prompt.select("Select an ingredient to remove", (menu_prompt))
end



