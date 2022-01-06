require 'mechanize'
require 'selenium-webdriver'
require "date"
require 'time'


class ScrapeNetflix
  
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
      product = Product.find_by(list:"https://www.netflix.com/title/#{d.attribute("data-id")}")
      topten = Topten.where(period_id:period_id,category:category,list:"https://www.netflix.com/title/#{d.attribute("data-id")}").first_or_initialize
      
      if product
        topten.product_id = product.id
        topten.title = product.title
        topten.rank = i
       
      else
        topten.title = d.find_elements(:tag_name,"td")[1].text
        topten.rank = i

      end
      topten.save
      i += 1
    end
  end

end