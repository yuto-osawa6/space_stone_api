require 'mechanize'
require 'syobocal'
require 'pp'

class ScrapeWiki
  # mechanaizeでジャンル

  def chrome
    chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    driver = Selenium::WebDriver.for(
      :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
      desired_capabilities: chrome_capabilities
    )
    return driver
  end
  def wiki
    chrome()
    @product = Product.where.not(wiki:nil)
    @year = Year.all
    @season = Kisetsu.where(id:[2,3,4,5])

    @year.each do |i|
      @product = Product.where.not(wiki:nil).joins(:year_season_products).where(year_season_products:{year_id:i.id})
      @product
    end
   
    url = "https://ja.wikipedia.org/wiki/%E3%82%86%E3%82%8B%E3%82%AD%E3%83%A3%E3%83%B3%E2%96%B3"
    driver.navigate.to(url)
    sleep(10)
  
    puts driver.find_element(:xpath, "//*[contains(text(), 'ジャンル')]").text
    puts driver.find_element(:xpath, "//*[contains(text(), 'ジャンル')]/../td").text
  end


  def select_wiki
    puts "yearを入力してください。"
    year = gets.chomp
    @year = Year.find_by(year:"#{year}-01-01")
    # puts @year.id
    @product = Product.where.not(wiki:nil).joins(:year_season_products).where(year_season_products:{year_id:@year.id})
    # puts @product.ids
    driver = chrome()
    @product.each do |i|
      getInfo(i.wiki,i.id,driver)
    end

  end 

  def getInfo(wiki,id,driver)
    url = wiki
    driver.navigate.to(url)
    sleep(10)

    begin
    genres = driver.find_element(:xpath, "//*[contains(text(), 'ジャンル')]/../td").text
    puts genres  
    rescue => exception
      puts exception
    end

  end

  # mechanize --------------(未完成）

  def m_select_wiki
    puts "yearを入力してください。"
    year = gets.chomp
    @year = Year.find_by(year:"#{year}-01-01")
    @product = Product.where.not(wiki:nil).joins(:year_season_products).where(year_season_products:{year_id:@year.id})
    @product.each do |i|
      m_getInfo(i.wiki,i.id,i.shoboiTid)
    end
    # m_getInfo(@product[0].wiki,@product[0].id)


  end

  def m_getInfo(link,id,tid)
    @product = Product.find(id)
    # puts link,id
    agent = Mechanize.new
    agent.request_headers = {
      'accept-language' => 'ja',
    }
    page = agent.get(link)
    begin
      genres = page.at("//*[contains(text(), 'ジャンル')]/../td")
      # genres = page.at("//*[contains(text(), 'ジャンル')]/../td").inner_text.split("、")

      genres_array = []
      genres.each do |g|
        # puts "a"
        puts g.inner_text
        # puts "g"
        # @genre = Janl.where(name:g).first_or_initialize
        # @genre.save
        genres_array << @genre
      end
    # @product.janls = genres_array
    rescue => exception
      puts exception
    end

    # if tid != nil
    #   # getStudios(tid,id)
    # end
  end 



  def getStudios(tid,id)
    @product = Product.find(id)
    title = Syobocal::DB::TitleLookup.get({'TID' => "#{tid}"})
    comment = title.first[:comment]
    begin
      studio = comment.match(/アニメーション制作.+/)
      studios = "#{studio}".split(":")[1].split("、")
      studio_array = []
      studios.each do |i|
        @studio = Studio.where(company:i).first_or_initialize
        @studio.save
        studio_array << @studio
      end
      @product.studios = studio_array
      @product.save
    rescue => exception
      puts exception
    end
  end
end

