require 'github/markup'
GitHub::Markup.render(file, File.read(file))


# Recipalooza! - Recipe_Findder-App
 App created with Ruby, Active Record, and TTY

 ## Table of Contents 
 * [General info](#general-info) 
 * [Technologies](#technologies) 
 * [Usage](#usage)
 * [Status](#status) 
 * [Credit](#credit)


### General info 
This project is our first project after completing mod 1 out of 5 at Flatiron Bootcamp, and inspired by the spoonacular api. This does not require installing any database and runs from the command line interface. It does require installing some ruby gem files to run fully from your CLI. be sure to install all bundles before moving on. 

### Technologies 
* sqlite3
* activerecord (5.0.7.2)
* tty (0.5.0)
* ruby
* rails (5.0.7.2)

### Usage 

Here, we will take you step by step through Recipalooza and show off all the cool features!

Upon loading the program, you will be prompted to "Login or Signup", when you enter a unique username, your data will be saved into our database and you can recall it later by using the same name. cApItAlIzAtIoN doesn't matter. 

Once logged in, you will be taken to a home menu which has 5 options.

1. View pantry:
Within view pantry you will have a menu that lists all of your pantry items. You can add or remove items through the menu, and selecting a pantry item itself will no nothing in 1.0 release. New features are in the works!
The most exciting feature is search for recipes. You must have at least 3 recipes to run a search, and the connected API will return recipes if they contain all of those ingredients!

2. View Favorite Recipes 
This feature stores all recipes the user has liked to be accessible in the future. The user will have the option of removing a recipe from their list of favorites, viewing a link to the recipe instructions via a url, search for additonal recipes, or going back to the homepage to access additional features.

3. Search 
This feature allows the user to access a vast database of recipes via the spoonacular api. The user will simply input up to 3 ingredients available in their pantry - if none exists - in order to search for recipes based on those ingredients.

4. View Edit Reviews 
The user can select one of their favorite recipes in order to: 
    a. view reviews written by themselves or by other users for that recipe 
    b. edit a review they have written 
    c. write a review for any recipe in their favorite recipe list. 

## Status
App is fully functional from CLI depending on bundle updates

## Credit 
 * https://spoonacular.com
 * https://ttytoolkit.org
 * http://www.ruby2d.com
 * https://www.text-image.com


