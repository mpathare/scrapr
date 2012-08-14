class Scraper
  BLACKLIST = ["transparent", "icon", "banner", "sprite"]

  attr_reader :response

  def initialize
    @response = {}
  end

  def scrape(url)
    begin
      url = "http://#{url}" unless url[0..3] == "http"
      page = Nokogiri::HTML(open(url))
      @uri = URI.parse(url)
      @host = @uri.host
      @scheme = @uri.scheme
      get_images(page)
      get_title(page)
      get_description(page)
      @response.merge({ status: "OK" })
    rescue Exception => e
      @response.merge({ status: "Fail" })
    end
    @response
  end

  def get_title(page)
    @response.merge({ title: page.title })
  end

  def get_description(page)
    @response.merge({ description: page.css("meta[name='description']").first.attributes['content'].value })
  end

  def get_images(page)
    page.xpath('//*[@itemprop="image"]').each { |node| add_image node, 'content' }
    page.css('img').each { |node| add_image node, 'src' }
    @response.merge({ images: @images })
  end

  private

  def add_image(node, val)
    debugger
    image_name = node.attributes[val].value.split("/").last.downcase
    @images << build_img_url(node.attributes[val].value) unless @images.include?(node.attributes[val].value) || is_blacklisted?(image_name)
  end

  def is_blacklisted?(image_name)
    blacklisted = false
    BLACKLIST.each do |blacklist|
      blacklisted = true if image_name.index(blacklist)
    end
    blacklisted
  end

  def build_img_url(src)
    if src.scan(/(http|https):\/\//).empty?
      url = "#{@scheme}://#{@host}"
      url += "/" unless src[0] == '/'
      url += src
    else
      src
    end
  end
end
