class Game
  def initialize(user, design_id)
    @user = user
    @design_id = design_id
  end

  def process_step0(name, color)
    change_page(Form.create_step1(@user, color, name))
  end

  def process_step1(action_taken)
    if action_taken =~ /Pick up/
      change_page(Form.create_step2(@user, @design_id))
    elsif action_taken == "Go back to sleep"
      change_page(Form.create_step1b(@user, @design_id))
    else
      title = 'Wallowing leads to sadness, sadness leads to anger and anger leads to suffering.'
      description = 'Several days later some adventurers find someone sat in a cave staring blankly at the wall.'

      change_to_death(title, description)
    end
  end

  def process_step2(strength_level)
    if strength_level <= 1
      message_only_page('The object looks quite heavy!', "You’ll have to try harder than that.", step = '2retry')

    elsif strength_level <= 2
      title = 'The object is a sharp, shiny sword forged from the finest Japanese steel, which you struggle to pick up.'
      description = 'Losing balance, you drop the sword which lands on your foot and causes you to pass out.'

      change_to_death(title, description)
    elsif strength_level == 5
      title = 'You lunge towards the object and lift it with all your stength.'
      description = 'As you ponder what happened, the shiny sword forged from the finest Japanese steel slices off your arms. Perhaps you were a little over zealous?'

      change_to_death(title, description)
    else
      change_page(Form.create_step3(@user, @design_id))
    end
  end

  def process_step2_failure
    change_page(Form.create_step2(@user, @design_id))
  end

  def process_step3(investigate_further)
    if investigate_further
      change_page(Form.create_step4(@user, @design_id))
    else
      change_to_death('You sit and wait, it\'s mysteriously quiet and you start to feel uncomfortable.', 'You hear a mysterious bellowing roar from the direction of the noise and the cave starts to collapse and you start to struggle for air.')
    end
  end

  def process_step4(door_picked)
    if door_picked == "Door 1"
      change_page(Form.create_step_dragon(@user, @design_id))
    elsif door_picked == "Door 2"
      change_to_death("You thought there was happiness there, didn’t you?", "You thought wrong.")
    else
      message_only_page("You fight the monster with your sword!", "In an epic battle, you emerge victorious!", 'win')
    end
  end

  def process_step_dragon(fight_the_dragon)
    if fight_the_dragon
      change_to_death("Why would you pick a fight with a dragon? As you unsheath your sword the dragon swarms towards you and consumes you whole.", "As you contemplate your impending digestion, you hear the dragon weeping, perhaps it didn't want to eat you after all?")
    else
      message_only_page("The dragon is very friendly!", "You climb on top of it and fly freely across the heavens!", 'win')
    end
  end

  def process_death
    FinishedGame.create!(outcome: "loss")
    Pusher.trigger(@user, 'death', {})
  end

  def process_win
    FinishedGame.create!(outcome: "win")
    Pusher.trigger(@user, 'win', {})
  end

  private

  def change_page(url)
    Pusher.trigger(@user, 'change_page', { new_url: url })
  end

  def change_to_death(title, description) 
    message_only_page(title, description, 'dead')
  end

  def message_only_page(title, description, next_step) 
    details = {
      title: title,
      description: description,
    }

    change_page(Form.create_message_only_step(@user, @design_id, details, next_step))
  end

end
