# require 'mechanize'
# require 'selenium-webdriver'
# require "date"
# require 'time'

# # 順番 products_movie products_tvshow setup_janl_links oo1 product_end
# # 1~5 月ごと  5は時々。

# class Scraping

#   def self.war
#     puts("waaaaaaaaaaa")
#   end
 
#   def self.en
#     require 'selenium-webdriver'
#     chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
#     driver = Selenium::WebDriver.for(
#       :remote,
#       url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
#       desired_capabilities: chrome_capabilities
#     )
#     driver.get('http://www.google.com')
#     driver.navigate.to "https://www.oddspark.com" #URL指定
#     puts driver.title #ページタイトルを出力
#   end

#   def self.oi
#     driver.navigate.to "http://www.google.com" #URL指定
#     puts driver.title #ページタイトルを出力

#     element = driver.find_element(:name, 'description') #セレクタ指定
#     puts element.attribute('content') #コンソールに出力

#     driver.quit 

#   end

#   def self.products_movie
#     link = "https://www.netflix.com/jp/browse/genre/34399?so=su"

#     movie = 1

#     products_list(link,movie)

#   end

#   def self.products_tvshow

#     link = "https://www.netflix.com/jp/browse/genre/83?so=su"

#     products_list(link,movie=0)
#   end

#   def self.netflixlogin
#     # driver = Selenium::WebDriver.for :chrome
#     chrome_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
#     driver = Selenium::WebDriver.for(
#       :remote,
#       url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
#       desired_capabilities: chrome_capabilities
#     )
  
#     driver.get("https://www.netflix.com/jp/login")
#     driver.find_element(:id, "id_userLoginId").send_keys(ENV["n_id"])
#     driver.find_element(:id, "id_password").send_keys(ENV["n_password"])
#     driver.find_element(:class, "login-button").click
  
#     wait = Selenium::WebDriver::Wait.new(timeout: 10)
#     wait.until { driver.find_element(:class, 'profile-icon').displayed? }
  
#     driver.find_element(:class, "profile-link").click
  
#     wait = Selenium::WebDriver::Wait.new(timeout: 10)
#     wait.until { driver.find_element(:class, 'account-menu-item').displayed? }

#     return driver

#   end

#   def self.netflix(driver,url)
#     driver.navigate.to(url) 
  
#     driver.find_element(:class, "aro-grid-toggle").click
#     driver.find_element(:class, "sortGallery").click
  
#     driver.find_elements(:class, "sub-menu-item")[3].click
  
#     35.times do
#       sleep(3)
#       driver.execute_script('window.scroll(0,1000000);')
#     end
  
#     sleep(3)

#     number_list = []
#     eleme = driver.find_elements(:class, "slider-refocus")
#     eleme.each do |a|
#       number_list.append(a.attribute("href").slice(/\d+/))
#     end
  
#     print number_list
#     puts number_list.uniq.length
#     puts number_list[-1]

#     driver.find_element(:class, "aro-grid-toggle").click
#     driver.find_element(:class, "sortGallery").click
#     driver.find_elements(:class, "sub-menu-item")[2].click
#     35.times do 
#       sleep(3)
#       driver.execute_script('window.scroll(0,1000000);') 
#     end
  
#     sleep(3)

#     eleme2 = driver.find_elements(:class, "slider-refocus")
#     eleme2.each do |a|
#       number_list.append(a.attribute("href").slice(/\d+/))
#     end

#     print number_list
#     puts number_list.uniq.length
#     puts number_list[-1]

#     title = driver.find_element(:class, "genreTitle").text

#     print title

#     links = number_list.uniq

#     if movie = 1

#     end

#     return links,title

#   end

#   def self.oo1
    
#     print "開始位置を入力してください"
#     start = gets.chomp.to_i

#     driver = netflixlogin()
#     # genre = Janl.all
#     Janl.find_in_batches(batch_size: 5,start:start) do |i|
#       print "あああああああああああああ"
#       # print i
#       all_netflix(i,driver)
#     end

#   end


#   def self.all_netflix(i,driver)
#     # driver = netflixlogin()
#     # products = Product.all
#     # genre = Janl.all


#     all_links = []
#     i.each do |a|
      
#       if a.link.present?
#         links,title = netflix(driver,a.link)
#         all_links = (all_links + links).uniq
#         print "aaa"
#         print all_links.length
#       end

#     end

#     print all_links.length
#     # 配列の結合

#     links2 = []
#     Product.all.each do |a|
#       links2.append(a.list.slice(/\d+/))
#     end 

#     links3 = all_links - links2

#     print "bbb"
#     print all_links.length
#     print links2.length
#     print links3.length
#     print "ccc"

#     links3.each do |link|
#       get_book("https://www.netflix.com/title/#{link}",go = 0)
#     end

#   end


#   def self.products_list(url,movie)

#     driver = netflixlogin()

#     links,title = netflix(driver,url)

#     print links
#     print title
#     links.each do |link|
#       get_book("https://www.netflix.com/title/#{link}",title)
#     end
#   end
  




#   def self.get_book(links,janl_name)

#     link = links
#     style = janl_name

#     agent = Mechanize.new
#     agent.request_headers = {
#       'accept-language' => 'ja',
#     }
#     begin
#       page = agent.get(link)
#       # puts page.at(".")

#       # title = page.at('.previewModal--section-header strong').inner_text if page.at('.previewModal--section-header strong')
#       title = page.at(".title-title").inner_text if page.at('.title-title')
#       cast = page.search(".item-cast") if page.search('.item-cast')
#       detail = page.at(".title-info-synopsis").inner_text if page.at('.title-info-synopsis')
#       janl = page.search(".item-genres") if page.search('.item-genres')

#       image = page.at(".hero-image-desktop")[:style].slice(/h.*"/).chop!

      

#       cast.each do |c|
#         puts c


#       end

#       janl.each do |c|
#         puts c
#       end
#       puts detail
#       puts image

#       if style == 0

#       else
#         style_book = Style.where(name:style).first_or_initialize
#         style_book.save
#       end
#       # puts image_reg

#       list = []
#       cast.each do |c|
#         cast_book = Cast.where(name: c.inner_text).first_or_initialize
#         cast_book.save
#         list << cast_book.id
#       end
#       puts list

#       # national_list = []
#       # style_list = []
#       list2 = []

#       janl.each do |c|
    
#         if c.inner_text.include?("、")
#           alfa = c.inner_text.delete("、")
#           puts alfa
#           cast_book = Janl.where(name: alfa).first_or_initialize
#           cast_book.save
#           list2 << cast_book.id
#         else
#           puts c.inner_text
#           puts c
#           cast_book = Janl.where(name: c.inner_text).first_or_initialize
#           cast_book.save
#           list2 << cast_book.id
#         end
      



#       end

#       book = Product.where(title: title).first_or_initialize
#       book.image_url = image
#       book.description = detail
#       book.list = link 
#       # book.end_day = end_day1
#       # book.image_url = image_url
#       book.cast_ids = list.uniq
#       book.janl_ids = list2.uniq
#       if style == 0

#       else
#         book.style_ids = style_book.id
#       end
#       book.finished = false

#       puts link
      
#       # book.detail = detail
#       book.save

     
      
      
      


      

#     rescue Mechanize::ResponseCodeError
#       # book = Product.where(link: link)
#       # book.finished = true
#       # book.save
#       # puts "Hello World!!#{link}"
#     end
#   end


#   # def self.product_update



#   # end

#   def self.product_end

#     driver = netflixlogin()
#     # driver = driver
#     print "開始位置を入力してください"
#     start = gets.chomp.to_i

#     # lists = []
#     book = Product.all
#     book.find_in_batches(batch_size: 50,start:start) do |b|

#       b.each do |c|
    
#       book_to = Product.find(c.id)
#       list = c.list
#       print list

#       driver.navigate.to(list)

#     begin
#       if driver.current_url == list
          

#         wait = Selenium::WebDriver::Wait.new(timeout: 50)
#         wait.until { driver.find_element(:class, 'about-header').displayed? }

#         # puts "aaa"

#         # book_to.janl
#         # janl = driver.find_element(:class, "about-container").find_elements(:class, "previewModal--tags")[1].find_elements(:class, "tag-item")
#         # # janl_field = driver.find_elements(relative: {tag_name: 'a', below: janl})

#         # janl_list = {}
#         # janl.each do |a|
#         #   # print a.text.delete("、")
#         #   # print a.attribute("href")
#         #   janl_list.store(a.find_element(:tag_name,"a").text.delete(","),a.find_element(:tag_name,"a").attribute("href"))
#         # end



#         # print janl_list

#         # janl_list.each do |a,b|
#         #   janl_field = Janl.find_by(name: a)
#         #   janl_field.link = b
#         #   janl_field.save
#         # end

        

#         if driver.find_element(:class, 'supplemental-message').displayed?

#           puts driver.find_element(:class, 'supplemental-message').displayed?
#         # wait.until { driver.find_element(:class, 'supplemental-message').displayed? }

#           title = driver.find_element(:class, "supplemental-message").text

#           book_to.end_day = title
#           book_to.save

#         end
#       else
#         # book = Product.where(list: list)
#         book_to.finished = true
#         book_to.save
#       end
#     rescue Selenium::WebDriver::Error::NoSuchElementError

#     # rescue Mechanize::ResponseCodeError
#     #   book = Product.where(link: link)
#     #   book.finished = true
#     #   book.save
#     #   # puts "Hello World!!#{link}"
#     end
#           # lists << list
#     end
#       end
#   end


#   def self.otamesi2(links,driver)
    
#     #指定したURLに遷移する
#     driver.navigate.to(links)

#     wait = Selenium::WebDriver::Wait.new(timeout: 50)
#     wait.until { driver.find_element(:class, 'about-container').displayed? }

#     #I'm Feeling Luckyボタン要素をname属性名から取得
#     # element = driver.find_element(:name,'btnI')

#     # janl = driver.find_element(:class, "about-container").find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[2].find_elements(:class, "tag-item")
#     janl1 = driver.find_element(:class, "about-container")
#     janl2 = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")

#     if janl2.length == 2
#       janl = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[1].find_elements(:class, "tag-item")
#     elsif janl2.length == 4
#       janl = janl1.find_elements(:xpath, "//*[@data-uia='previewModal--tags-genre']")[2].find_elements(:class, "tag-item")
#     end
#     janl.each do |b|
#       print b.text
#     end
#     # print aaa
#     # janl_field = driver.find_elements(relative: {tag_name: 'a', below: janl})

#     janl_list = {}
#     janl.each do |a|
#       # print a.text.delete("、")
#       # print a.attribute("href")
#       janl_list.store(a.find_element(:tag_name,"a").text.delete(","),a.find_element(:tag_name,"a").attribute("href"))
#     end



#     print janl_list

#     janl_list.each do |a,b|
#       janl_field = Janl.find_by(name: a)
#       janl_field.link = b
#       janl_field.save
#     end

#   end


#   def self.otamesi4

#     driver = netflixlogin()
#     links,title = netflix(driver,url="https://www.netflix.com/jp/browse/genre/34399?so=su")

#     links2 = []
#     Product.all.each do |a|
#       links2.append(a.list.slice(/\d+/))
#     end 

#     links3 = links - links2

#     print links2.length
#     print  "い"
#     print links.length
#     print "あ"
#     print links3.length

#     links3.each do |link|
#       get_book("https://www.netflix.com/title/#{link}",title)
#     end

#   end


#   def self.setup_janl_links
#     driver = netflixlogin()
#     genre = Janl.all
#     list = []
#     # list_name = []
#     genre.each do |g|
#       list << g.products.first.list
#       # g.products.first.janls.each do |a|
#         #  list_name << a.name 

#       # end
#     end
    
#     lists = list.uniq

#     # print list_name.uniq
#     # print list_name.uniq.length
#     lists.each do |g|
#       otamesi2(g,driver)
#     end
#     # otamesi2(url="https://www.netflix.com/title/81442047",driver)
#   end


#   # def self.otamesi3

#   #   text = "国内、"
#   #   text1= text.delete("、")
#   #   print text1


#   # end



#   # def self.login

#   #   agent = Mechanize.new
#   #   agent.max_history = 2
#   #   agent.user_agent_alias = 'Mac Firefox'
#   #   agent.conditional_requests = false

#   #   login_page = agent.get('https://www.netflix.com/jp/login')
#   #   puts login_page.title
#   #   # puts login_page.search(".")

#   #   login_form = login_page.form_with(class: 'login-form')

#   #   login_form.field_with(name: 'userLoginId').value = 
#   #   login_form.field_with(name: 'password').value = 

#   #   logined_page = login_form.submit

#   #   # top_agent = agent.get('https://www.netflix.com/browse/genre/83?so=su')
#   #   # puts top_agent.search(".")

#   #   # puts user_page.title

#   #   # logout_form = user_page.form_with(name: 'logout')
#   #   # sleep 1
#   #   # pp logout_form

#   #   # sleep 1
#   #   # logout_page = logout_form.submit
#   #   # puts logout_page.title


#   # end 

#   # def self.set_list_page
#   #   agent = Mechanize.new
#   #   agent.request_headers = {
#   #     # 'Origin' => 'https://michadameyo.com',
#   #     'accept-language' => 'ja',
#   #     # 'Upgrade-Insecure-Requests' => '1',
#   #     # 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
#   #   }
#   #   # agent.max_history = 2
#   #   agent.user_agent_alias = 'Mac Safari 4'
#   #   # agent.conditional_requests = false

#   #   # top_agent = agent.get('https://www.netflix.com/browse/genre/83?so=su')
#   #   # agent.user_agent_alias = 'Mac Safari'
#   #   top_agent = agent.get('https://www.netflix.com/browse/genre/83?so=az')
#   #   puts top_agent.search(".")

#   #   number_lists = []

#   #   # number = page.at(".title-title").inner_text

#   #   elements = top_agent.search('.nm-content-horizontal-row-item a')
#   #   elements.each do |ele|
#   #     number_lists << ele.get_attribute('href').slice(-8,8)
#   #   end

#   #   puts number_lists.uniq.length

#   #   puts number_lists[-1]

#   #   # number_lists.each do |link|
#   #   #   get_book("https://www.netflix.com/title/#{link}")
#   #   # end
#   # end

#   # def self.one

#   #   https://www.netflix.com/jp-en/title/81091393


#   # end

#   # def work_params
#   #   params.require(:product).permit(:title,image, :description,  { cast_ids: [] })
#   # end
# end