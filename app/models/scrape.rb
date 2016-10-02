class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :runtime, :synopsis, :failure

  def scrape_new_movie
    begin
      doc = Nokogiri::HTML(open("https://www.rottentomatoes.com/m/the_martian/"))
      doc.css('script').remove
      self.title = doc.css("//h1.title.hidden-xs").text.strip
      self.hotness = doc.css("//.meter-value").text.to_i
      self.image_url = doc.css("//.posterImage").attribute('src').text
      self.rating = doc.css("//div.col.col-sm-19.col-xs-14.text-left").first.text
      self.director = doc.css("//div.col-sm-19.col-xs-14.text-left")[2].text.strip
      self.genre = doc.css("//div.col-sm-19.col-xs-14.text-left")[1].text.strip
      self.runtime = doc.css("//div.col-sm-19.col-xs-14.text-left")[6].text.strip

      # preventing encoding problems
      s = doc.css("#movieSynopsis").text.strip
      if ! s.valid_encoding?
        s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      end
      self.synopsis = s

      return true
    rescue Exception => e
      self.failure = e
    end
  end

  def save_movie
    movie = Movie.new(
      title: self.title,
      hotness: self.hotness,
      image_url: self.image_url,
      synopsis: self.synopsis,
      rating: self.rating,
      genre: self.genre,
      director: self.director,
      runtime: self.runtime
      )
    movie.save
  end

end # class
