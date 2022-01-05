require 'mechanize'
require 'selenium-webdriver'
require "date"
require 'time'

# 順番 最初 products_movie products_tvshow setup_janl_links oo1 product_end
# 追記 週一 product_new product_scheduled setup_janl_links oo1  product_end

class ScrapeProducts
  def war
    puts("waaaaaaaaaaa")
  end

  # movie 一覧
  def products_movie
    link = "https://www.netflix.com/jp/browse/genre/34399?so=su"
    movie = 1
    products_list(link,movie)
  end
  # tv show 一覧
  def products_tvshow
    link = "https://www.netflix.com/jp/browse/genre/83?so=su"
    products_list(link,movie=0)
  end
  # netflixログイン
  def netflixlogin
    # driver = Selenium::WebDriver.for :chrome
    chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    driver = Selenium::WebDriver.for(
      :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
      desired_capabilities: chrome_capabilities
    )
    driver.get("https://www.netflix.com/jp/login")
    driver.find_element(:id, "id_userLoginId").send_keys(ENV["n_id"])
    driver.find_element(:id, "id_password").send_keys(ENV["n_password"])
    driver.find_element(:class, "login-button").click
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(:class, 'profile-icon').displayed? }
    driver.find_element(:class, "profile-link").click
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(:class, 'account-menu-item').displayed? }
    
    return driver

  end
  # 作品一覧の表示 
  def netflix(driver,url)
    driver.navigate.to(url) 
    driver.find_element(:class, "aro-grid-toggle").click
    driver.find_element(:class, "sortGallery").click
    driver.find_elements(:class, "sub-menu-item")[3].click
  
    35.times do
      sleep(3)
      driver.execute_script('window.scroll(0,1000000);')
    end
  
    sleep(3)

    number_list = []
    eleme = driver.find_elements(:class, "slider-refocus")
    eleme.each do |a|
      number_list.append(a.attribute("href").slice(/\d+/))
    end
  
    print number_list
    puts number_list.uniq.length
    puts number_list[-1]

    driver.find_element(:class, "aro-grid-toggle").click
    driver.find_element(:class, "sortGallery").click
    driver.find_elements(:class, "sub-menu-item")[2].click
    35.times do 
      sleep(3)
      driver.execute_script('window.scroll(0,1000000);') 
    end
  
    sleep(3)

    eleme2 = driver.find_elements(:class, "slider-refocus")
    eleme2.each do |a|
      number_list.append(a.attribute("href").slice(/\d+/))
    end

    print number_list
    puts number_list.uniq.length
    puts number_list[-1]
    title = driver.find_element(:class, "genreTitle").text
    print title
    links = number_list.uniq

    return links,title

  end
  #productのリンクを獲得
  def products_list(url,movie)

    driver = netflixlogin()

    links,title = netflix(driver,url)

    print links
    print title
    links.each do |link|
      get_book("https://www.netflix.com/title/#{link}",title,news=0)
    end
  end
  #productの内容の獲得 追記new エラーチェックまだしてない。
  def get_book(links,janl_name,new_product)

    link = links
    style = janl_name

    agent = Mechanize.new
    agent.request_headers = {
      'accept-language' => 'ja',
    }
    begin
      page = agent.get(link)
      # puts page.at(".")

      # title = page.at('.previewModal--section-header strong').inner_text if page.at('.previewModal--section-header strong')
      title = page.at(".title-title").inner_text if page.at('.title-title')
      cast = page.search(".item-cast") if page.search('.item-cast')
      detail = page.at(".title-info-synopsis").inner_text if page.at('.title-info-synopsis')
      janl = page.search(".item-genres") if page.search('.item-genres')
      image = page.at(".hero-image-desktop")[:style].slice(/h.*"/).chop!

      

      cast.each do |c|
        puts c
      end

      janl.each do |c|
        puts c
      end
      puts detail
      puts image

      if style == 0

      else
        style_book = Style.where(name:style).first_or_initialize
        style_book.save
      end

      list = []
      cast.each do |c|
        cast_book = Cast.where(name: c.inner_text).first_or_initialize
        cast_book.save
        list << cast_book.id
      end
      puts list
      list2 = []

      janl.each do |c|
    
        if c.inner_text.include?("、")
          alfa = c.inner_text.delete("、")
          puts alfa
          cast_book = Janl.where(name: alfa).first_or_initialize
          cast_book.save
          list2 << cast_book.id
        else
          puts c.inner_text
          puts c
          cast_book = Janl.where(name: c.inner_text).first_or_initialize
          cast_book.save
          list2 << cast_book.id
        end
      end

      book = Product.where(title: title).first_or_initialize
      book.image_url = image
      book.description = detail
      book.list = link 
      # book.end_day = end_day1
      # book.image_url = image_url
      book.cast_ids = list.uniq
      book.janl_ids = list2.uniq
      if style == 0

      else
        book.style_ids = style_book.id
      end
      #消しました注意!!!!!
      # book.finished = false
      # 追記注意
      if new_product == 1
        book.new_content = true
      end

      puts link
      
      # book.detail = detail
      book.save

    rescue Mechanize::ResponseCodeError
      # book = Product.where(link: link)
      # book.finished = true
      # book.save
      # puts "Hello World!!#{link}"
    end
  end

  def sample
    url = "https://www.netflix.com/title/81330849"
    agent = Mechanize.new
    agent.request_headers = {
      'accept-language' => 'ja',
    }
    page = agent.get(url)
    puts page.at(".")

  end

  def sample2
    # doneyet(sleep時間、ページの読み込みがおわるまでに変える必要ある。)
    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    # options.add_argument('--lang=ja-JP')

    # chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    url="https://www.netflix.com/jp/title/81143589"

    # url="https://www.netflix.com/jp/title/81511191"
    # 80107103

    # driver = Selenium::WebDriver.for(
    #   :remote,
    #   url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
    #   desired_capabilities: chrome_capabilities,
    #   # options:options
    # )
    driver = netflixlogin()
    driver.navigate.to(url)
    # ltr-111bn9j 

    # wait = Selenium::WebDriver::Wait.new(timeout: 30)
    # wait.until { driver.find_element(:class, 'dropdown-toggle').displayed? }
    sleep(5)
    puts "sff"
    puts driver.find_elements(:class, 'dropdown-toggle').length
    puts "lll"
    if driver.find_elements(:class, 'dropdown-toggle').length > 0
      # puts driver.find_element(:class, 'dropdown-toggle').displayed?

      driver.find_element(:class, 'dropdown-toggle').click
      season = driver.find_elements(:class, 'ltr-bbkt7g').length
      # puts driver.find_elements(:class, 'dropdown-toggle').length

      puts  season
      driver.find_elements(:class, 'ltr-bbkt7g')[season-1].click

      puts driver.find_elements(:class, 'episodeSelector-season-label').length
      puts driver.find_elements(:class, 'episodeSelector-season-label')

      # driver.find_elements(:class, 'titleCard-title_index').each.with_index(1) do |i,a|
      puts driver.find_elements(:class, 'titleCard-title_index').length


      # wait = Selenium::WebDriver::Wait.new(timeout: 30)
      # wait.until { driver.find_element(:class, 'episodeSelector-season-label')[season-1].displayed? }
      sleep(5)

      1.times do
        # sleep(3)
        driver.execute_script('window.scroll(0,1000000);')
      end

      puts driver.find_elements(:class, 'titleCardList-title').length
      puts driver.find_elements(:class, 'titleCard-synopsis').length
      puts driver.find_elements(:class, 'episodeSelector-season-label').length
      puts driver.find_elements(:class, 'duration').length

      puts driver.find_elements(:class, 'episodeSelector-season-label').length


      puts driver.find_elements(:class, 'ellipsized').length
      puts driver.find_elements(:class, 'previewModal--small-text').length
      # previewModal--small-text
      puts driver.find_elements(:class, 'ptrack-content').length


      a=1
      l=1
      s=1
      driver.find_elements(:class, 'titleCard-title_index').each do |i|

        # a = 1
        puts i.text
        puts a
        if i.text == a.to_s
        # a += 1
        puts a
        puts "aaaaaa"
        else
          # puts i.text,a
        a = 1
        s += 1
        # a += 1
        puts"lllllllllll"
        end
        puts a
        # puts driver.find_elements(:class, 'titleCardList-title')[l].text
        # Episord.where(episord:a,product_id:1,season:s).first_or_create do |e|
        @episord= Episord.where(episord:a,product_id:1,season:s).first_or_initialize do |e|

          # e.episord = a
          # e.product_id = 1
          e.title = driver.find_elements(:class, 'titleCardList-title')[l-1].find_element(:class, 'titleCard-title_text').text
          e.arasuzi = driver.find_elements(:class, 'titleCard-synopsis')[l-1].text
          # # e.season = s
          e.season_title = driver.find_elements(:class, 'episodeSelector-season-label')[s-1].text
          # 0の値が別にあるため、+1してます。
          e.time =  driver.find_elements(:class, 'duration')[l-1+1].text
          e.image = driver.find_elements(:class, 'titleCard-imageWrapper')[l-1].find_element(:class, 'ptrack-content').find_element(:tag_name, 'img').attribute('src')
          # titleCard-imageWrapper
        end
        @episord.save
        l += 1
        a += 1

      end
     
    else
      puts "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
      # collapsed
      driver.find_element(:class, 'collapsed').find_element(:tag_name, 'button').click
      1.times do
        # sleep(3)
        driver.execute_script('window.scroll(0,1000000);')
      end
      puts driver.find_elements(:class, 'collapsed')

      a = 1
      l = 1
      driver.find_elements(:class, 'titleCard-title_index').each do |i|

        # a = 1
        puts i.text
        puts a
        @episord= Episord.where(episord:a,product_id:2,season:1).first_or_initialize do |e|

          # e.episord = a
          # e.product_id = 1
          e.title = driver.find_elements(:class, 'titleCardList-title')[l-1].find_element(:class, 'titleCard-title_text').text
          e.arasuzi = driver.find_elements(:class, 'titleCard-synopsis')[l-1].text
          # # e.season = s
          e.season_title = "シーズン1"
          # 0の値が別にあるため、+1してます。
          e.time =  driver.find_elements(:class, 'duration')[l-1+1].text
          e.image = driver.find_elements(:class, 'titleCard-imageWrapper')[l-1].find_element(:class, 'ptrack-content').find_element(:tag_name, 'img').attribute('src')
          # titleCard-imageWrapper
        end
        @episord.save
        l += 1
        a += 1

      end
     
    end
    puts "aaaaaa"

  end
  # ジャンルのリンクを取得
  def setup_janl_links
    driver = netflixlogin()
    genre = Janl.all
    list = []
    # list_name = []
    genre.each do |g|
      list << g.products.first.list
      # g.products.first.janls.each do |a|
        #  list_name << a.name 

      # end
    end
    
    lists = list.uniq

    # print list_name.uniq
    # print list_name.uniq.length
    lists.each do |g|
      otamesi2(g,driver)
    end
    # otamesi2(url="https://www.netflix.com/title/81442047",driver)
  end

  def otamesi2(links,driver)
    
    #指定したURLに遷移する
    driver.navigate.to(links)

    wait = Selenium::WebDriver::Wait.new(timeout: 50)
    wait.until { driver.find_element(:class, 'about-container').displayed? }

    #I'm Feeling Luckyボタン要素をname属性名から取得
    # element = driver.find_element(:name,'btnI')

    # janl = driver.find_element(:class, "about-container").find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[2].find_elements(:class, "tag-item")
    janl1 = driver.find_element(:class, "about-container")
    janl2 = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")

    if janl2.length == 2
      janl = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[1].find_elements(:class, "tag-item")
    elsif janl2.length == 4
      janl = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[2].find_elements(:class, "tag-item")
    end
    janl.each do |b|
      print b.text
    end
    # print aaa
    # janl_field = driver.find_elements(relative: {tag_name: 'a', below: janl})

    janl_list = {}
    janl.each do |a|
      # print a.text.delete("、")
      # print a.attribute("href")
      janl_list.store(a.find_element(:tag_name,"a").text.delete(","),a.find_element(:tag_name,"a").attribute("href"))
    end



    print janl_list

    janl_list.each do |a,b|
      janl_field = Janl.find_by(name: a)
      janl_field.link = b
      janl_field.save
    end

  end
  # 全ての作品を獲得
  def self.oo1
    
    print "開始位置を入力してください"
    start = gets.chomp.to_i

    driver = netflixlogin()
    # genre = Janl.all
    Janl.find_in_batches(batch_size: 5,start:start) do |i|
      print "あああああああああああああ"
      # print i
      all_netflix(i,driver)
    end

  end

  def self.all_netflix(i,driver)
    # driver = netflixlogin()
    # products = Product.all
    # genre = Janl.all


    all_links = []
    i.each do |a|
      
      if a.link.present?
        links,title = netflix(driver,a.link)
        all_links = (all_links + links).uniq
        print "aaa"
        print all_links.length
      end

    end

    print all_links.length
    # 配列の結合

    links2 = []
    Product.all.each do |a|
      links2.append(a.list.slice(/\d+/))
    end 

    links3 = all_links - links2

    print "bbb"
    print all_links.length
    print links2.length
    print links3.length
    print "ccc"

    links3.each do |link|
      get_book("https://www.netflix.com/title/#{link}",go = 0,news = 0)
    end

  end







  # 全ての作品の詳細など selenium product_end 追加カラム 、追加(year,message,during,episord)
  def product_end

    driver = netflixlogin()
    # driver = driver
    print "開始位置を入力してください"
    start = gets.chomp.to_i

    # lists = []
    book = Product.all
    book.find_in_batches(batch_size: 1,start:start) do |b|

      b.each do |c|
    
      book_to = Product.find(c.id)
      list = c.list
      print list

      driver.navigate.to(list)

    # begin
      if driver.current_url == list
          

        wait = Selenium::WebDriver::Wait.new(timeout: 50)
        wait.until { driver.find_element(:class, 'about-header').displayed? }

     
        
        puts driver.find_elements(:class, 'supplemental-message').length
        

        if driver.find_elements(:class, 'supplemental-message').length > 0

          puts driver.find_element(:class, 'supplemental-message').displayed?
          # puts driver.find_element(:class, 'supplemental-message').displayed?

        # wait.until { driver.find_element(:class, 'supplemental-message').displayed? }

          title = driver.find_element(:class, "supplemental-message").text

          book_to.end_day = title
          # book_to.save
        else
          book_to.end_day = ""

        end

        if driver.find_elements(:class, 'videoMetadata--second-line').length > 0
          book_to.year = driver.find_element(:class, 'videoMetadata--second-line').find_element(:class, 'year').text
          book_to.duration = driver.find_element(:class, 'videoMetadata--second-line').find_element(:class, 'duration').text

          puts driver.find_elements(:class, 'episodeSelector-label').length
          puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        else
          book_to.finished = true

        end

        # movie tvshow 判別(まだ正確かどうかわかっていないdoneyet)
        puts driver.find_elements(:class, 'episodeSelector-header').length
        if driver.find_elements(:class, 'episodeSelector-header').length > 0
          if driver.find_elements(:class, 'videoMetadata--second-line').length > 0
            book_to.style_ids = [2]
          else
            book_to.style_ids = [3]
          end

        else
          book_to.style_ids = [1]
        end

        # book_to.duration = 
        book_to.save

        # 
        # if driver.find_elements(:class, 'episodeSelector-label').length > 0
        #   book_to.style_ids[1]
        # else
        #   book_to.style_ids[2]
        # end
        


        # episords
        # if driver.find_element(:class, 'ltr-16khy1u').displayed?
        #   puts driver.find_element(:class, 'ltr-16khy1u').displayed?

        #   driver.find_element(:class, 'ltr-16khy1u').click
        #   driver.find_element(:class, 'ltr-bbkt7g').click

        #   episodeSelector-season-label
         
        # end
        product_id = c.id
        # if book_to.styles.
        episord_create(driver,product_id)
        # puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



      else
        # book = Product.where(list: list)
        book_to.end = true
        book_to.save
      end
    # rescue Selenium::WebDriver::Error::NoSuchElementError
    #   puts "2666666666666666666666666666666666666666666666666666666666"
    # rescue Mechanize::ResponseCodeError
    #   book = Product.where(link: link)
      # book.finished = true
      # book.save
    #   # puts "Hello World!!#{link}"
    # end
          # lists << list
    end
      end
  end
  # episordの情報を保存
  def episord_create(driver,product_id)
    if driver.find_elements(:class, 'dropdown-toggle').length > 0
      # puts driver.find_element(:class, 'dropdown-toggle').displayed?

      driver.find_element(:class, 'dropdown-toggle').click
      season = driver.find_elements(:class, 'ltr-bbkt7g').length
      # puts driver.find_elements(:class, 'dropdown-toggle').length

      puts  season
      driver.find_elements(:class, 'ltr-bbkt7g')[season-1].click

      puts driver.find_elements(:class, 'episodeSelector-season-label').length
      puts driver.find_elements(:class, 'episodeSelector-season-label')

      # driver.find_elements(:class, 'titleCard-title_index').each.with_index(1) do |i,a|
      puts driver.find_elements(:class, 'titleCard-title_index').length


      # wait = Selenium::WebDriver::Wait.new(timeout: 30)
      # wait.until { driver.find_element(:class, 'episodeSelector-season-label')[season-1].displayed? }
      sleep(5)

      1.times do
        # sleep(3)
        driver.execute_script('window.scroll(0,1000000);')
      end

      puts driver.find_elements(:class, 'titleCardList-title').length
      puts driver.find_elements(:class, 'titleCard-synopsis').length
      puts driver.find_elements(:class, 'episodeSelector-season-label').length
      puts driver.find_elements(:class, 'duration').length

      puts driver.find_elements(:class, 'episodeSelector-season-label').length


      puts driver.find_elements(:class, 'ellipsized').length
      puts driver.find_elements(:class, 'previewModal--small-text').length
      # previewModal--small-text
      puts driver.find_elements(:class, 'ptrack-content').length


      a=1
      l=1
      s=1
      driver.find_elements(:class, 'titleCard-title_index').each do |i|

        # a = 1
        puts i.text
        puts a
        if i.text == a.to_s
        # a += 1
        puts a
        puts "aaaaaa"
        else
          # puts i.text,a
        a = 1
        s += 1
        # a += 1
        puts"lllllllllll"
        end
        puts a
        # puts driver.find_elements(:class, 'titleCardList-title')[l].text
        # Episord.where(episord:a,product_id:1,season:s).first_or_create do |e|
        @episord= Episord.where(episord:a,product_id:product_id,season:s).first_or_initialize do |e|

          # e.episord = a
          # e.product_id = 1
          e.title = driver.find_elements(:class, 'titleCardList-title')[l-1].find_element(:class, 'titleCard-title_text').text
          e.arasuzi = driver.find_elements(:class, 'titleCard-synopsis')[l-1].text
          # # e.season = s
          e.season_title = driver.find_elements(:class, 'episodeSelector-season-label')[s-1].text
          # 0の値が別にあるため、+1してます。
          e.time =  driver.find_elements(:class, 'duration')[l-1+1].text
          e.image = driver.find_elements(:class, 'titleCard-imageWrapper')[l-1].find_element(:class, 'ptrack-content').find_element(:tag_name, 'img').attribute('src')
          # titleCard-imageWrapper
        end
        @episord.save
        l += 1
        a += 1

      end
     
    else
      puts "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
      # collapsed
      
      if driver.find_elements(:class, 'collapsed').length > 0
        driver.find_element(:class, 'collapsed').find_element(:tag_name, 'button').click
      end
      1.times do
        # sleep(3)
        driver.execute_script('window.scroll(0,1000000);')
      end
      puts driver.find_elements(:class, 'collapsed')

      a = 1
      l = 1
      driver.find_elements(:class, 'titleCard-title_index').each do |i|

        # a = 1
        puts i.text
        puts a
        @episord= Episord.where(episord:a,product_id:product_id,season:1).first_or_initialize do |e|

          # e.episord = a
          # e.product_id = 1
          e.title = driver.find_elements(:class, 'titleCardList-title')[l-1].find_element(:class, 'titleCard-title_text').text
          e.arasuzi = driver.find_elements(:class, 'titleCard-synopsis')[l-1].text
          # # e.season = s
          e.season_title = "シーズン1"
          # 0の値が別にあるため、+1してます。
          e.time =  driver.find_elements(:class, 'duration')[l-1+1].text
          e.image = driver.find_elements(:class, 'titleCard-imageWrapper')[l-1].find_element(:class, 'ptrack-content').find_element(:tag_name, 'img').attribute('src')
          # titleCard-imageWrapper
        end
        @episord.save
        l += 1
        a += 1

      end
     
    end
  end 
  # 新着作品の情報を獲得
  def product_new
    driver = netflixlogin()
    url = "https://www.netflix.com/latest"
    driver.navigate.to(url)

    list = []
    num = 3
    loop do
    # 4.times do |i|
      puts num
    driver.action.move_to(driver.find_elements(:class, 'lolomoRow')[0].find_element(:class, "slider-item-#{num}")).perform
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until { driver.find_element(:class, 'focus-trap-wrapper').displayed? }
      # puts driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
      driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk')[3].click

      current_url = driver.current_url.slice(/\d+/)
      # puts current_url
      list << current_url
      driver.find_element(:class,'previewModal-close').click
      num -= 1
      puts list
      puts num
      sleep(3)
      if num == -1 
        puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        driver.action.move_to(driver.find_elements(:class,'handleNext')[0]).perform
        sleep(2)
        puts driver.find_elements(:class,'indicator-icon').length
        puts "iiiiiiiiii"
        driver.find_elements(:class,'handleNext')[0].find_element(:class,'indicator-icon').click
        break
      end
    end
    # end
    # driver.action.move_to(driver.find_elements(:class,'indicator-icon')[0]).perform
    # driver.find_element(:class,'indicator-icon').click
    sleep(2)

    num = 4
    loop do
      # puts num
    driver.action.move_to(driver.find_elements(:class, 'lolomoRow')[0].find_element(:class, "slider-item-#{num}")).perform
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until { driver.find_element(:class, 'focus-trap-wrapper').displayed? }
      # puts driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
      driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk')[3].click

      current_url = driver.current_url.slice(/\d+/)
      puts current_url
      list << current_url
      sleep(1)

      driver.find_element(:class,'previewModal-close').click
      num -= 1
      puts list
      sleep(3)

      if num == 0
        num = 4
        driver.action.move_to(driver.find_elements(:class,'handleNext')[0]).perform
        sleep(2)
        # puts driver.find_elements(:class,'indicator-icon').length
        driver.find_elements(:class,'handleNext')[0].find_element(:class,'indicator-icon').click
        sleep(2)
      end

      if (list.count - list.uniq.count) > 0 
        break
      end

    end


    # new情報の更新

    # b_list = []
    # before_new = Product.where(new_content:true)
    # before_new.each do |b|
    #   b_list.append(b.list.slice(/\d+/))
    #   b.new_content = false
    #   b.save
    # end

    list = list.uniq

    # b_list - list

    puts "a"
    puts list
    puts "a"

    list.each do |link|
      get_book("https://www.netflix.com/title/#{link}",go=0,new_product=1)
    end
  end

  # 配信予定作品の情報を獲得
  def product_scheduled
    driver = netflixlogin()
    url = "https://www.netflix.com/latest"
    driver.navigate.to(url)

    driver.execute_script("arguments[0].scrollIntoView();",driver.find_elements(:class, 'lolomoRow')[1].find_element(:class, "slider-item-#{0}") )

    list = []
    # num = 0
    ii = 2
    3.times do |i|
    # list{i} =[]
    # instance_variable_set("list#{i}",[])
    list[i] = []
    # puts "h"
    # puts 
    # puts "h"
    num = 3
      loop do
      # 4.times do |i|
        puts num
      driver.action.move_to(driver.find_elements(:class, 'lolomoRow')[ii].find_element(:class, "slider-item-#{num}")).perform
        wait = Selenium::WebDriver::Wait.new(timeout: 10)
        wait.until { driver.find_element(:class, 'focus-trap-wrapper').displayed? }
        puts driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
        len = driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
        driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk')[len-1].click

        current_url = driver.current_url.slice(/\d+/)
        # puts current_url
        list[i] << current_url
        sleep(2)
        driver.find_element(:class,'previewModal-close').click
        num -= 1
        puts  list[i]
        puts num
        sleep(3)
        if num == -1 
          puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
          driver.action.move_to(driver.find_elements(:class,'handleNext')[ii]).perform
          sleep(2)
          puts driver.find_elements(:class,'indicator-icon').length
          puts "iiiiiiiiii"
          driver.find_elements(:class,'handleNext')[ii].find_element(:class,'indicator-icon').click
          break
        end
      end
    # end
    # driver.action.move_to(driver.find_elements(:class,'indicator-icon')[0]).perform
    # driver.find_element(:class,'indicator-icon').click
    sleep(2)

    num = 4
      loop do
        # puts num
      driver.action.move_to(driver.find_elements(:class, 'lolomoRow')[ii].find_element(:class, "slider-item-#{num}")).perform
        wait = Selenium::WebDriver::Wait.new(timeout: 10)
        wait.until { driver.find_element(:class, 'focus-trap-wrapper').displayed? }
        puts driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
        len = driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk').length
        driver.find_element(:class, 'focus-trap-wrapper').find_elements(:class,'ltr-79elbk')[len-1].click

        current_url = driver.current_url.slice(/\d+/)
        puts current_url
        list[i] << current_url
        sleep(2)

        driver.find_element(:class,'previewModal-close').click
        num -= 1
        puts list[i]
        sleep(3)

        if num == 0
          num = 4
          driver.action.move_to(driver.find_elements(:class,'handleNext')[ii]).perform
          sleep(2)
          # puts driver.find_elements(:class,'indicator-icon').length
          driver.find_elements(:class,'handleNext')[ii].find_element(:class,'indicator-icon').click
          sleep(2)
        end

        if (list[i].count - list[i].uniq.count) > 0 
          break
        end

      end
      ii += 1
      puts ii
      puts i

    end
      
      list = list[0]+list[1]+list[2]
      list = list.uniq
      puts "a"
      puts list[0]
      puts list[0].length
      puts "a"
      puts list[1]
      puts list[1].length
      puts "a"
      puts list[2]
      puts list[2].length
      puts "a"

      puts "a"
      puts list
      puts list.length
      puts "a"

      

      list.each do |link|
        get_book("https://www.netflix.com/title/#{link}",go=0,o=0)
      end
    # end
    
  end

  # new情報の更新
  # def
    
  # end

  # aboutnetflix new情報獲得
  def aboutnetflix()
    chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    driver = Selenium::WebDriver.for(
      :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
      desired_capabilities: chrome_capabilities
    )

    url = "https://about.netflix.com/ja/new-to-watch"
    driver.navigate.to(url)
    sleep(5)
    #スクロール
    driver.execute_script('window.scroll(0,1000000);') 
    len = driver.find_elements(:class, "ejJeDM").length

    number_list = []

    len.times do |i|
      # eleme = driver.find_elements(:class, "cGrGmh")
      eleme = driver.find_elements(:class, "ehxjCL")

      eleme.each do |a|
        number_list.append(a.find_element(:class, "cGrGmh").attribute("href").slice(/\d+/))
      end
      if i == len -1
        break
      end
      driver.find_elements(:class, "ejJeDM")[i+1].find_element(:tag_name,"button").click
      sleep(5)
      driver.execute_script('window.scroll(0,1000000);') 
      # puts number_list
    end
    puts number_list.uniq

    number_list.uniq.each do |link|
      get_book("https://www.netflix.com/title/#{link}",go=0,new_product=0)
    end


  end
end