def get_username
    prompt = TTY::Prompt.new
    prompt.ask("What is your name?")
  end  


def ingredient_prompt
    prompt = TTY::Prompt.new
    prompt.ask("What ingredients do you have in your kitchen?")
  end


  def create_user
    name = get_username
    user = nil
      User.all.each do |u| if u.name == name
        user = u
      end
    end
      if user == nil
      User.create(name: name)
      user = User.last 
      end
      user
    end
