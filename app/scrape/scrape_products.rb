require 'mechanize'
require 'selenium-webdriver'
require "date"
require 'time'

class ScrapeProducts
  def war
    puts("waaaaaaaaaaa")
  end

  def products_movie
    link = "https://www.netflix.com/jp/browse/genre/34399?so=su"
    movie = 1
    products_list(link,movie)
  end

  def products_tvshow
    link = "https://www.netflix.com/jp/browse/genre/83?so=su"
    products_list(link,movie=0)
  end

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

  def products_list(url,movie)

    driver = netflixlogin()

    links,title = netflix(driver,url)

    print links
    print title
    links.each do |link|
      get_book("https://www.netflix.com/title/#{link}",title)
    end
  end

  def get_book(links,janl_name)

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
      book.finished = false

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

    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    # options.add_argument('--lang=ja-JP')

    # chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    url="https://www.netflix.com/jp/title/81143589"
    # driver = Selenium::WebDriver.for(
    #   :remote,
    #   url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
    #   desired_capabilities: chrome_capabilities,
    #   # options:options
    # )
    driver = netflixlogin()
    driver.navigate.to(url)
    # ltr-111bn9j 

    wait = Selenium::WebDriver::Wait.new(timeout: 30)
    wait.until { driver.find_element(:class, 'dropdown-toggle').displayed? }
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
          e.title = driver.find_elements(:class, 'titleCardList-title')[l-1].text
          e.arasuzi = driver.find_elements(:class, 'titleCard-synopsis')[l-1].text
          # # e.season = s
          e.season_title = driver.find_elements(:class, 'episodeSelector-season-label')[s-1].text
          # 0の値が別にあるため、+1してます。
          e.time =  driver.find_elements(:class, 'duration')[l-1+1].text
          e.image = driver.find_elements(:class, 'ptrack-content')[l-1].find_element(:tag_name, 'img').attribute('src')
        end
        @episord.save
        l += 1
        a += 1

      end
     

     
    end
    puts "aaaaaa"

  end

  # selenium product_end 追加カラム
  def product_end

    driver = netflixlogin()
    # driver = driver
    print "開始位置を入力してください"
    start = gets.chomp.to_i

    # lists = []
    book = Product.all
    book.find_in_batches(batch_size: 50,start:start) do |b|

      b.each do |c|
    
      book_to = Product.find(c.id)
      list = c.list
      print list

      driver.navigate.to(list)

    begin
      if driver.current_url == list
          

        wait = Selenium::WebDriver::Wait.new(timeout: 50)
        wait.until { driver.find_element(:class, 'about-header').displayed? }

     
        
        
        

        if driver.find_element(:class, 'supplemental-message').displayed?

          puts driver.find_element(:class, 'supplemental-message').displayed?
        # wait.until { driver.find_element(:class, 'supplemental-message').displayed? }

          title = driver.find_element(:class, "supplemental-message").text

          book_to.end_day = title
          book_to.save

        end

        # episords
        if driver.find_element(:class, 'ltr-16khy1u').displayed?
          puts driver.find_element(:class, 'ltr-16khy1u').displayed?

          driver.find_element(:class, 'ltr-16khy1u').click
          driver.find_element(:class, 'ltr-bbkt7g').click

          episodeSelector-season-label
         
        end



      else
        # book = Product.where(list: list)
        book_to.finished = true
        book_to.save
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError

    # rescue Mechanize::ResponseCodeError
    #   book = Product.where(link: link)
    #   book.finished = true
    #   book.save
    #   # puts "Hello World!!#{link}"
    end
          # lists << list
    end
      end
  end


end