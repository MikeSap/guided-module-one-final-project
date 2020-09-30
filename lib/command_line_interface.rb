

def welcome  
  puts "Welcome to Recipalooza!!!"
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

    user = create_user
    prompt = TTY::Prompt.new
    selection = prompt.select("Welcome to your pantry! You can add/remove an item or return home!") do |menu|
      menu.choice "Add Item"
      user.pantry_names.each {|name| menu.choice name}
      menu.choice "Home"
      menu.choice "Remove an ingredient"       
    end
    if selection == "Home"
      home
    elsif selection == "Add Item"
      user.create_pantry_ingredients
      pantry
    elsif selection == "Remove an ingredient"
      prompt = TTY::Prompt.new
      selection2 = prompt.select("Select an ingredient to remove") do |menu|
      user.pantry_names.each {|ing| menu.choice ing}
      menu.choice "Home"        
      end
      if selection2 == "Home"
        home
      else
      ing_to_remove = Ingredient.all.find_by_name(selection2).id
      removed_ing = Ingredient.all.find_by_name(selection2).name
      user.pantry_ingredients.destroy(ing_to_remove)
      puts "#{removed_ing} has been removed from your pantry"
      home
    end
  else
    #show ingredient nutritional value?
  end
end

def view_favorite_recipes
  user = create_user
  prompt = TTY::Prompt.new
    selection = prompt.select("Select a recipe to see more info, or return home") do |menu|
      user.favorite_recipes.each {|rec| menu.choice rec.name}
      menu.choice "Home"
      menu.choice "Remove a recipe"
    end    
    if selection == "Home"
      home
    elsif selection == "Remove a recipe"
      prompt = TTY::Prompt.new
      selection2 = prompt.select("Select a recipe to remove") do |menu|
      user.favorite_recipes.each {|rec| menu.choice rec.name}
      menu.choice "Home"
      end 
    if selection2 == "Home"
        home
    else 
      rec_to_remove = user.favorite_recipes.find_by_name(selection2).id
      removed_name = user.favorite_recipes.find_by_name(selection2).name
      user.favorite_recipes.destroy(rec_to_remove)      
      puts "#{removed_name} has been removed from your favorite recipes"
      home 
    end    
      else
      #send to another page with recipe info (open browser?)
      home
    end
end

def search
  user = create_user
  if user.pantry.length < 3
    puts "You must have at least 3 items in your pantry before searching."
    # 3.times{user.create_pantry_ingredients}    
  view_pantry
   else
    prompt = TTY::Prompt.new
    selection = prompt.multi_select("What would you like to cook with?", (user.pantry_names))
  end
  recipes = get_recipes_from_api(selection)
  prompt = TTY::Prompt.new
    recipes_select = prompt.multi_select("What recipe would you like to add to your favorites?", (recipes))
    recipes_select.each do
    |rec| fav =  FavoriteRecipe.create(name:rec, user_id: user.id)
    puts "You added #{rec} to your favorites!"
    end   
  home
end

