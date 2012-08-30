class Scraper
  require 'open-uri'

  BLACKLIST = ["sprite", "icon", "transparent"]

  def initialize(url)
    begin
      @response = { "status" => "ok"}
      @page = Nokogiri::HTML(open(url))
    rescue Exception => e
      @response.merge!({ "status" => "fail" })
    end
  end

  def scrape(options = {})
    unless @response["status"] == "fail"
      @response.merge!({ "title" => '', "description" => '', "images" => [] })
      @image_limit = options[:image_limit]
      get_title
      get_description
      get_images
    end
    @response
  end

  private

  def get_title
    @response["title"] = @page.title
  end

  def get_description
    @page.css("meta").each do |meta|
      if meta.attributes['name'] && meta.attributes['name'].value.downcase == "description"
        @response["description"] = meta.attributes['content'].value
      end
    end
  end

  def get_images
    @page.css('img').each { |img| parse_image(img, 'src') }
    @page.xpath('//*[@itemprop="image"]').each { |node| parse_image(node, 'content') }
  end

  def parse_image(node, val)
    image_name = node.attributes[val].value.split("/").last.downcase
    path = node.attributes[val].value
    unless @response["images"].include?(node.attributes[val].value) || Scraper::BLACKLIST.any? { |blacklist| image_name.index(blacklist) }
      @response['images'] << path if under_returned_images_limit?
    end
  end

  def under_returned_images_limit?
    if @image_limit
      @response['images'].size < @image_limit.to_i
    else
      true
    end
  end
end
