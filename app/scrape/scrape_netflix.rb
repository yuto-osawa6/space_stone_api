require 'mechanize'
require 'selenium-webdriver'
require "date"
require 'time'


class ScrapeNetflix
  # a
  #世界ランキング
  def period
    chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    driver = Selenium::WebDriver.for(
      :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
      desired_capabilities: chrome_capabilities
    )

    urllist = []
    urllist.append("films")
    urllist.append("films-non-english")
    urllist.append("tv")
    urllist.append("tv-non-english")
   
    url = "https://translate.google.co.jp/translate?u=https://top10.netflix.com/films"
    driver.navigate.to(url)
    sleep(10)

    puts "aaaaaaaa"
    puts driver.find_elements(:class, "select-week")[1].text
    puts "bbbbbbb"
    period_text = driver.find_elements(:class, "select-week")[1].text
    period = Period.where(period:period_text).first_or_initialize
    period.save

    urllist.each do |a|
      driver.navigate.to("https://translate.google.co.jp/translate?u=https://top10.netflix.com/#{a}")
      sleep(5)
      top10(driver,period.id)
    end


  end
  #人気があったもの
  def top10(driver,period_id)
    # list-table  
    i = 1
    driver.find_elements(:class, "list-table")[0].find_elements(:tag_name, "tbody")[0].find_elements(:tag_name,"tr").each do |d|
      category = driver.find_elements(:class, "css-1vm6co7-container")[1].find_elements(:class,"css-1d8n9bt")[0].text
      puts product = Product.where(list:"https://www.netflix.com/title/#{d.attribute("data-id")}")

      topten = Topten.where(period_id:period_id,category:category,list:"https://www.netflix.com/title/#{d.attribute("data-id")}").first_or_initialize
      # 追記
      sleep(1)
      img = driver.find_elements(:class,"banner-image")[i-1].attribute("src")

      # puts product.length
      if product.length == 0
        topten.product_id = nil
      else
        topten.product_id = product[0].id
      end
      
      topten.rank = i
      topten.title = d.find_elements(:tag_name,"td")[1].text
      topten.image_url = img
      topten.save
      i += 1
    end
  end

  def ren
    # chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
    # driver = Selenium::WebDriver.for(
    #   :remote,
    #   url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
    #   desired_capabilities: chrome_capabilities
    # )
    # url = "https://translate.google.co.jp/translate?u=https://top10.netflix.com/films"
    # driver.navigate.to(url)
    # driver.find_elements(:class,"banner-image").each do |a|
    #   a.attribute("src")
    # end

    # puts driver.find_elements(:class,"banner-image")[0].attribute("src")
    # puts driver.find_elements(:class,"banner-image")[9].attribute("src")
    puts Product.where(list:"https://www.netflix.com/title/60004481").length

  end

end