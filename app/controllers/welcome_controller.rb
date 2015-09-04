#
# This is hackathon quality code! 
# Please do not use in production.
#

class WelcomeController < ApplicationController
  before_action :set_default_response_format, :except => [:index]

  def index
    @current_user = SecureRandom.hex(8)
    @step0_url = Form.create_step0(@current_user)

    @games = FinishedGame.count
    @wins = FinishedGame.where(outcome: "win").count
    @losses = FinishedGame.where(outcome: "loss").count
  end

	def step0
    name = params[:answers].detect { |answer| answer[:type] == "text" }[:value]
    color = params[:answers].detect { |answer| answer[:type] == "choice" }[:value][:label].downcase

    game.process_step0(name, color)

		render :json => { status: :ok }
	end

  def step1
    action_taken = params[:answers].first[:value][:label]

    game.process_step1(action_taken)

    render :json => { status: :ok }
  end

  def step2
    strength_level = params[:answers].first[:value][:amount]

    game.process_step2(strength_level)

    render :json => { status: :ok }
  end

  def step2retry
    game.process_step2_failure

    render :json => { status: :ok }
  end
  
  def step3
    investigate = params[:answers].first[:value]

    game.process_step3(investigate)

    render :json => { status: :ok }
  end

  def step4
    door_picked = params[:answers].first[:value][:label]

    game.process_step4(door_picked)
  end

  def step_dragon
    fight_dragon = params[:answers].first[:value]

    game.process_step_dragon(fight_dragon)

    render :json => { status: :ok }
  end

  def dead
    game.process_death

    render :json => { status: :ok }
  end

  def win
    game.process_win

    render :json => { status: :ok }
  end

  protected

  def set_default_response_format
    request.format = :json
  end

  private

  def game
    Game.new(params[:user], Array(params[:tags]).first)
  end
end
