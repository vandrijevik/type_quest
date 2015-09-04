class Design
  def initialize(color)
    @color = color.to_sym
  end

  def create
    design = faraday.post(
      "/v0.4/designs",
      attrs,
      { "x-api-token" => ENV["TYPEFORM_KEY"] }
    )

    design.body["id"]
  end

private
  def attrs
    {
      colors: color,
      font: "Source Sans Pro"
    }
  end

  def color
    case @color
    when :blue
      {
        question: '#FCF7C2',
        button: '#285975',
        answer: '#FFFFFF',
        background: '#285975',
      }

    when :red
      {
        question: '#000000',
        button: '#B33A3A',
        answer: '#FFFFFF',
        background: '#B33A3A',
      }

    when :green
      {
        question: '#FFFFFF',
        button: '#E6E8A9',
        answer: '#FDFFC7',
        background: '#B0C275',
      }

    when :yellow
      {
        question: '#000000',
        button: '#000000',
        answer: '#383838',
        background: '#FED83E',
      }

    when :pez
      {
        question: '#FFFFFF',
        button: '#FDC539',
        answer: '#FAD05C',
        background: '#292929',

      }

    else
      {
        question: '#81B8B9',
        button: '#81B8B9',
        answer: '#181B28',
        background: '#FFFFFF',
      }
    end
  end

  def faraday
    @faraday ||= Faraday.new(url: "https://api.typeform.io/") do |faraday|
      faraday.request :json
      faraday.adapter Faraday.default_adapter

      faraday.response :json
    end
  end
end
