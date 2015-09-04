#
# This is hackathon quality code! 
# Please do not use in production.
#

class Form
  attr_reader :attrs
  attr_reader :step
  attr_reader :user

  def self.create_step0(user)
    attrs = {
      title: "Let’s play a game",
      design_id: 'gezkjCEFUh', # default color schema
      fields: [
        {
          type: "short_text",
          question: "What is your name?",
          required: true,
        },
        {
          type: "multiple_choice",
          question: "What is your favorite color?",
          required: true,
          choices: [
            { label: "Red" },
            { label: "Green" },
            { label: "Blue" },
            { label: "Yellow" },
            { label: "White" },
          ],
        }
      ]
    }

    Form.new(user, 0, attrs).create
  end

  def self.create_step1(user, color, name)
    design_id = Design.new(color).create

    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "multiple_choice",
          question: "Hello #{name}! You wake up in a dark, cold cave. You are not sure how you got there, but there is an object in front of you.",
          description: "What do you do?",
          required: true,
          choices: [
            { label: "Pick up the object" },
            { label: "Go back to sleep" },
            { label: "Wallow in self-pity" },
          ],
        },
      ]
    }

    Form.new(user, 1, attrs).create
  end

  def self.create_step1b(user, design_id)
    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "multiple_choice",
          question: "Hello again! You wake up in a dark, cold cave. You are not sure how you got there, but there is an object in front of you.",
          description: "You feel slightly better rested, what do you do now?",
          required: true,
          choices: [
            { label: "Pick up the object, which you dreamt was potentially dangerous" },
            { label: "Go back to sleep" },
            { label: "Wallow in self-pity" },
          ],
        },
      ]
    }

    Form.new(user, 1, attrs).create
  end

  def self.create_step2(user, design_id)
    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "rating",
          question: "You are standing in front of the object.",
          description: "How strong do you feel?",
          required: true,
        },
      ]
    }

    Form.new(user, 2, attrs).create
  end

  def self.create_step3(user, design_id)
    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "yes_no",
          question: "An unfamiliar sound is coming from the direction of the cave’s entrance.",
          description: "Do you want to have a closer look?",
          required: true,
        },
      ]
    }

    Form.new(user, 3, attrs).create
  end

  def self.create_step4(user, design_id)
    # happydoor - rsagAjJgQ8
    # monsterdoor - cZx8HFNH36
    # dragondoor - LUmiB8SP9p

    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "picture_choice",
          question: "You follow the noise and reach three doors",
          description: "Which door do you go through?",
          required: true,
          choices: [
            {
              image_id: 'LUmiB8SP9p',
              label: "Door 1" # dragon
            },
            {
              image_id: 'rsagAjJgQ8',
              label: "Door 2" # happy
            },
            {
              image_id: 'cZx8HFNH36',
              label: "Door 3" # monster
            }
          ]
        },
      ]
    }

    Form.new(user, 4, attrs).create
  end

  def self.create_step_dragon(user, design_id)
    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "yes_no",
          question: "As you slowly open the door, you notice the temperature increases. The door slams shut behind you, and a battle scarred fire breathing dragon's nostrils flare as it smells you enter the room.",
          description: "You jump behind a cold stone pillar and reach for your sword, are you ready to fight?",
          required: true,
        },
      ]
    }

    Form.new(user, 5, attrs).create
  end

  def self.create_message_only_step(user, design_id, details, next_step) 
    attrs = {
      title: "Let’s play a game",
      design_id: design_id,
      tags: [design_id],
      fields: [
        {
          type: "statement",
          question: details[:title],
          description: details[:description],
          required: true,
        },
      ]
    }

    Form.new(user, next_step, attrs).create
  end

  def initialize(user, step, attrs)
    @user = user
    @step = step
    @attrs = attrs
  end

  def create
    form = faraday.post(
      "/v0.4/forms",
      attrs.merge(common_form_params),
      { "x-api-token" => ENV["TYPEFORM_KEY"] }
    )
    form.body["_links"].detect do |link|
      link["rel"] == "form_render"
    end["href"]
  end

private
  def webhook_url
    [
      "http://",
      Rails.application.config.domain,
      "/step#{step}/#{user}"
    ].join
  end

  def faraday
    @faraday ||= Faraday.new(url: "https://api.typeform.io") do |faraday|
      faraday.request :json
      faraday.adapter Faraday.default_adapter

      faraday.response :json
    end
  end

  def common_form_params
    {
      webhook_submit_url: webhook_url,
    }
  end
end
