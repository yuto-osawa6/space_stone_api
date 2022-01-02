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
    chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    url="https://www.netflix.com/jp/title/81330849"
    driver = Selenium::WebDriver.for(
      :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
      desired_capabilities: chrome_capabilities
    )
    driver.navigate.to(url) 

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

        # puts "aaa"

        # book_to.janl
        # janl = driver.find_element(:class, "about-container").find_elements(:class, "previewModal--tags")[1].find_elements(:class, "tag-item")
        # # janl_field = driver.find_elements(relative: {tag_name: 'a', below: janl})

        # janl_list = {}
        # janl.each do |a|
        #   # print a.text.delete("、")
        #   # print a.attribute("href")
        #   janl_list.store(a.find_element(:tag_name,"a").text.delete(","),a.find_element(:tag_name,"a").attribute("href"))
        # end



        # print janl_list

        # janl_list.each do |a,b|
        #   janl_field = Janl.find_by(name: a)
        #   janl_field.link = b
        #   janl_field.save
        # end

        

        if driver.find_element(:class, 'supplemental-message').displayed?

          puts driver.find_element(:class, 'supplemental-message').displayed?
        # wait.until { driver.find_element(:class, 'supplemental-message').displayed? }

          title = driver.find_element(:class, "supplemental-message").text

          book_to.end_day = title
          book_to.save

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