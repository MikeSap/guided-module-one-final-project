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
      # user = create_user
      pantry_names = @user.pantry_names
      prompt = TTY::Prompt.new
      selection = prompt.select("Select an item to remove. You can also add new item, or return home") do |menu|
        menu.choice "Add Item"
        pantry_names.each {|name| menu.choice name}
        menu.choice "Home"      
      end
      if selection == "Home"
        home
      elsif selection == "Add Item"
        ingredient_prompt
        @user.create_pantry_ingredients
        view_pantry
      else
        ing_to_remove = Ingredient.all.find_by_name(selection).id
        removed_ing = Ingredient.all.find_by_name(selection).name
        @user.pantry_ingredients.destroy(ing_to_remove)
        puts "#{removed_ing} has been removed from your pantry"
        view_pantry
      end
  end

  def view_favorite_recipes
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
    if @user.pantry.length < 3
      puts "You must have at least 3 items in your pantry before searching."
      # 3.times{user.create_pantry_ingredients}    
      view_pantry
    else
      prompt = TTY::Prompt.new
      selection = prompt.multi_select("What would you like to cook with?", (@user.pantry_names))
    end
    # prompt = TTY::Prompt.new
    # selection = prompt.multi_select("What would you like to cook with?", (user.pantry_names))
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