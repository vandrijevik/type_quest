class Image
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def create(url)
    image = faraday.post(
      "/v0.4/images",
      { url: url },
      { "x-api-token" => ENV["TYPEFORM_KEY"] }
    )

    image.body["id"]
  end

private
  def image_url 
    suckr = ImageSuckr::GoogleSuckr.new
    suckr.get_image_url({"q" => "wallpaper #{query}", "imgsz" => "xxlarge"})
  end

  def faraday
    @faraday ||= Faraday.new(url: "https://api.typeform.io/") do |faraday|
      faraday.request :json
      faraday.adapter Faraday.default_adapter

      faraday.response :json
    end
  end
end
