require 'faraday'
require 'nokogiri'

class Scraper
  def initialize; end

  def scrape_title(url)
    response_body = Faraday.get(url).body
    html = Nokogiri::HTML(response_body)
    html.at_css('span#ebooksProductTitle').text
  end

  def scrape_price(url)
    response_body = Faraday.get(url).body
    selector = 'tr.kindle-price td.a-color-price'
    html = Nokogiri::HTML(response_body)
    /£(\d+\.\d+)/.match(html.at_css(selector).children[0].to_xml(encoding: 'UTF-8').strip)[1].to_f
  end
end
