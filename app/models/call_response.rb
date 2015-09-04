class CallResponse
  attr_reader :country

  def initialize(country)
    @country = country || "UK"
  end

  def message
    messages(language)
  end

  def language
    language_for_country(country)
  end

  def to_xml
    doc = Ox::Document.new(:version => '1.0')

    response = Ox::Element.new("Response")
    doc << response

    say = Ox::Element.new("Say")
    say[:language] = language
    response << say

    say << message

    Ox.dump(doc)
  end

private
  def games
    FinishedGame.count
  end

  def wins
    FinishedGame.where(outcome: "win").count
  end

  def losses
    FinishedGame.where(outcome: "loss").count
  end

  def language_for_country(country)
    mapping = {
      "US" => "en-US",
      "ES" => "ca-ES",
      "UK" => "en-GB",
    }
    mapping[country]
  end

  def messages(language)
    mapping = {
      "en-US" => "Hello! #{games} games have been played so far! Of those, #{wins} have been wins, and #{losses} have been losses.",
      "en-GB" => "Good afternoon! #{games} games have been contested thus far! #{wins} players have been victorious, and #{losses} have not been as fortunate.",
      "ca-ES" => "Hola! Fins ara s'han jugat #{games} jocs! D'ells, #{wins} han estat victòries i #{losses} han estat derrotes.",
    }
    mapping[language]
  end
end
