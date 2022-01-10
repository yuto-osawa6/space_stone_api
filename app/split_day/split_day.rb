require "date"
class SplitDay

  def ren
    puts "productIdを入力してください"
    product_id = gets.to_i
    product = Product.find(product_id)

    text = product.end_day
    puts text
    # aaaaaaaa

    week = ["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"]
    # week_hash = {"月曜日"=>:monday,"火曜日"=>:,"水曜日",'木曜日','金曜日'=>:friday,'土曜日','日曜日'=>:sunday}
    # text = "火曜日に配信開始"
    # text2 = "火曜日"
    if week.any? { |t| text.include?(t)}
      week_selected = week.select { |i| text.include?(i) }
      today_week = Date.today.wday
      # week_hash作る。
      hash = {}
      i = 0
      s = 0
      week.each do |w|
        puts w
        if today_week+i > 6
          key = week[s]
          hash[key] = i
          s += 1
        else
          key = week[today_week+i]
          hash[key] = i
        end
        i += 1
      end
      puts hash
      puts later = hash[week_selected[0]]
      puts later_week = Date.today.since(later.days).strftime('%-m月%d日')
      puts re_text = text.delete(week_selected[0]+"に")
      puts rere_text = later_week + re_text
      # puts week[later_week]
      product.end_day = rere_text
      product.save

    end
  end

  def split_day
    # puts product1 = Product.find(3423).end_day
    # Product.update_all(pickup: 0,decision_news:0,delivery_end:"",delivery_start:"",episord_start:"")
    Product.update_all(pickup: 0,decision_news:0)

    re_product = Product.where("end_day LIKE ?", "%﻿%")
    re_product.each do |r|
      r.end_day = r.end_day.delete!('﻿')
      r.save
    end


    product_end = Product.where("end_day LIKE ?", "%配信終了%")
    product_end.each do |p1|
      text = p1.end_day.match(/\w+月+\w+日/)
      puts text
      if text != nil
        # puts "aaaaaaaa"
        text2 = Date.strptime("#{text}", '%m月%d日')
        puts text2
      end
      p1.delivery_end = text2
      p1.save
    end

    product_start = Product.where("end_day LIKE ?", "%配信開始%")
    product_start.each do |p1|
      text = p1.end_day.match(/\w+月+\w+日/)
      # puts text
      if text != nil
        puts "aaaaaaaa"
        text2 = Date.strptime("#{text}", '%m月%d日')
        puts text2
        else
        p1.decision_news = true
      end
      p1.delivery_start = text2
      p1.save
    end

    product_episord = Product.where("end_day LIKE ?", "%新着エピソード%")
    product_episord.each do |p1|
      text = p1.end_day.match(/\w+月+\w+日/)
      if text != nil
        # puts "aaaaaaaa"
        text2 = Date.strptime("#{text}", '%m月%d日')
        puts text2
      end
      p1.episord_start = text2
      p1.save
    end

    product_pickup = Product.where("end_day LIKE ?", "%今すぐ観よう%")
    product_pickup.each do |p1|
      text = p1.end_day.match(/\w+月+\w+日/)
      p1.pickup = true
      p1.save
    end

    # 配信決定

    product_decision = Product.where("end_day LIKE ?", "%配信決定%")
    product_decision.each do |p1|
      text = p1.end_day.match(/\w+月+\w+日/)
      p1.decision_news = true
      p1.save
    end
   
    puts product_decision.length
    puts product_end.length
    puts product_start.length
    puts product_episord.length
    puts product_pickup.length


 

    # {jugde number 1:netflix 2:article 3update}
    product3 = Product.where("end_day LIKE ?", "%信開%")

    product_news = Product.where(decision_news:true)
    product_news.each do |p|
      newmessage = Newmessage.where(description:p.end_day).first_or_initialize
      newmessage.title = p.title
      newmessage.judge = 1
      newmessage.save
    end
  end

end