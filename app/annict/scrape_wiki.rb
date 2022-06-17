require 'mechanize'
require 'syobocal'
require 'pp'
require "rexml/document"
require "open-uri"

class ScrapeWiki
  # mechanaizeでジャンル
  # shobocal と shobocal_db

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

  def shobocal_db
    puts "yearを入力してください。"
    year = gets.chomp
    if !Year.exists?(year:"#{year}-01-01")
      puts "yearがありません。"
      return 
    end
    puts "季節を入力してください(春・夏・秋・冬)"
    kisetsu = gets.chomp
    if !Kisetsu.exists?(name:"#{kisetsu}")
      puts "季節がありません。"
      return 
    end
    @year = Year.find_by(year:"#{year}-01-01")
    @kisetsu = Kisetsu.find_by(name:"#{kisetsu}")
    # .where.not(wiki:nil)
    @product = Product.joins(:year_season_products).where(year_season_products:{year_id:@year.id},year_season_products:{kisetsu_id:@kisetsu.id})
    @product.each do |i|
      m_getInfo(i.wiki,i.id,i.shoboiTid)
    end
  end

  def m_getInfo(link,id,tid)
    # doneyet-1(ジャンルが不規則で持ってこれない)
    # @product = Product.find(id)
    # # puts link,id
    # agent = Mechanize.new
    # agent.request_headers = {
    #   'accept-language' => 'ja',
    # }
    # page = agent.get(link)
    # begin
    #   genres = page.at("//*[contains(text(), 'ジャンル')]/../td")
    #   # genres = page.at("//*[contains(text(), 'ジャンル')]/../td").inner_text.split("、")

    #   genres_array = []
    #   genres.each do |g|
    #     # puts "a"
    #     puts g.inner_text
    #     # puts "g"
    #     # @genre = Janl.where(name:g).first_or_initialize
    #     # @genre.save
    #     genres_array << @genre
    #   end
    # # @product.janls = genres_array
    # rescue => exception
    #   puts exception
    # end

    if tid != nil
      getStudios(tid,id)
    end
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

  def shobocal
    puts "yearを入力してください。"
    year = gets.chomp
    puts "月を入力してください。"
    month = gets.chomp
    puts "追加したい日付を入力してください。"
    days = gets.chomp
    puts "何日後までのデーターを取得しますか。(7)"
    span = gets.chomp
    puts "#{year}-#{month}-#{days},days=#{span}でよろしかったですか。y/n}"
    yn = gets.chomp
    if yn == "n"
      puts "キャンセルされました。"
      return
    elsif yn != "y"
      puts "予期しない文字が入力されたため、キャンセルしました。"
      return
    end
    start = "#{year}-#{month}-#{days}"
    get_programs(span,start)
  end

  # しょぼいカレンダーから番組を取得する
  def get_programs(span,start)
    url = "http://cal.syoboi.jp/cal_chk.php?days=#{span}&start=#{start}" # span: どれくらい先まで取得するかの期間を日にちで指定
    xml = REXML::Document.new(open(url).read)

    programs = []

    xml.elements.each("syobocal/ProgItems/ProgItem") { |item|
      programs << {
        title: item.attribute("Title").to_s,                # タイトル
        sub_title: item.attribute("SubTitle").to_s,         # サブタイトル
        st_time: Time.parse(item.attribute("StTime").to_s), # 開始時刻
        ed_time: Time.parse(item.attribute("EdTime").to_s), # 終了時刻 
        Count: item.attribute("Count").to_s.to_i,
        tid: item.attribute("TID").to_s,
      }
    }
    
    programs.each do |shobo|
      if !Product.exists?(shoboiTid:shobo[:tid])
        puts 1
        next
      end

      product = Product.find_by(shoboiTid:shobo[:tid])
      if Episord.exists?(episord:shobo[:Count],product_id:product.id)
        episord = Episord.find_by(episord:shobo[:Count],product_id:product.id)
        if !episord.release_date.blank?
          if episord.release_date <= shobo[:st_time].to_datetime
            puts 2
            next
          end
          puts 2.5
          puts episord.release_date 
          puts shobo[:st_time]
          puts episord.release_date < shobo[:st_time].to_datetime
          episord.update(release_date:shobo[:st_time].to_datetime)
          next
        else
          puts 3
          episord.update(release_date:shobo[:st_time].to_datetime)
          next
        end
      end
      puts 4
      puts endtime1 = (shobo[:ed_time] - shobo[:st_time]).to_i
      puts endtime1
      endtime = Time.at(endtime1).utc.strftime('%X')
      puts endtime
      puts 86400 > endtime1
      Episord.create(product_id:product.id,title:shobo[:sub_title],episord:shobo[:Count],release_date:shobo[:st_time],time:endtime)
    end
    
  end

  def ota3
    # string = "203-3-1"
    # puts string.to_date
    # time = Time.current
    # go = time.ago(24.hours)
    # puts time - go
    # puts (time - go).to_i
    # puts Time.at(1440).utc.strftime('%X')
  end
end

