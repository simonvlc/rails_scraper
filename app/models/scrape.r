class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :runtime, :synopsys, :failure

  def scrape_new_movie
    begin
      doc = Nokogiri::HTML(open("http://www.rottentomatoes.com/m/the_martian/"))
      doc.css('script').remove
      self.title = doc.css("//h1.title.hidden-xs").text.strip
      self.hotness = doc.css("//.meter-value").text.to_i
      self.image_url = doc.css("//.posterImage").attribute('src').text
      self.rating = doc.css("//div.col.col-sm-19.col-xs-14.text-left").first.text
      self.director = doc.css("//div.col-sm-19.col-xs-14.text-left")[2].text.strip
      self.genre = doc.css("//div.col-sm-19.col-xs-14.text-left")[1].text.strip
      self.runtime = doc.css("//div.col-sm-19.col-xs-14.text-left")[6].text.strip
      self.synopsys = doc.css("#movieSynopsis").text.strip
      return true
    rescue Exception => e
      self.failure = "Something went wrong with the scrape"
    end
  end
end
