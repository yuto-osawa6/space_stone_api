class TagsSet
  def year_season_set
    product = Product.where("length(year) = 4").pluck(:year)
    product2 = Product.where("duration LIKE ?", "%シーズン%").pluck(:duration)

    # puts product.uniq
    product.each do |ps|
      year = Year.where(year:ps).first_or_initialize
      year.save
    end
    # product2.each do |ps|
    #   season = Season.where(season:ps).first_or_initialize
    #   season.save
    # end
  end
  # def ren
  #   # product = Product.where("length(year) = 4").pluck(:year)
  #   # puts product
  #   season = Season.where("length(season) < 14").pluck(:season)
  #   puts season
  
  def month_tags_set
    puts "月までの日付を入力してください（例202201）"
    month = gets.chomp
    month = "#{month}01"
    # puts month 
    month_set = MonthDuring.where(month:month).first_or_initialize
    month_set.month = month
    month_set.save

    # doneyet （あとで標本数を変える）
    # ランキング10まで,利用者に応じて変えていく。
    from = month_set.month.beginning_of_month
    # to = month_set.month.end_of_month
    to = month_set.month.next_month.beginning_of_month

    puts from
    puts to

    month_label = "[#{month_set.month.year}年#{month_set.month.month}月]"
    month_label2 = "#{month_set.month.year}年#{month_set.month.month}月"

    # アクセス(3)

    acsess = Acsess.where(date: from...to).order(count: "DESC").limit(100)
    # acsess = Acsess.where(date: from...to).order("count(count) desc").limit(50)
    i = 1
    pre = 0
    s = 0
    # doneyet (一応完成、ただアクセスランキングに変動があった場合、重複する（システム的には100%ない）)
    acsess.each do |a|
      if a.count == pre
        tags = Tag.where(product_id:a.product_id,month_during_id:month_set.id,genre:3).first_or_initialize
        tags.rank = s
        tags.tag = "#{month_label} アクセス数 ランキング ##{s}"
      else

        tags =Tag.where(product_id:a.product_id,month_during_id:month_set.id,genre:3).first_or_initialize
        tags.rank = i
        tags.tag = "#{month_label} アクセス数 ランキング ##{i}"
        s = i 
      end
      i += 1 
      pre = a.count
      # tags.genre = 3
      tags.month_title =  month_label2
      
      tags.save
      if i == 101
        break
      end
    end

    # スコア(2)
    score = Score.where(updated_at: from...to).group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(100).average(:value)
    # score.each do |k, v|
    #   puts k
    # end
    ii = 1
    pre2 = 0
    ss = 0
    score.each do |k, v|
      puts k
      if v == pre2
        tags = Tag.where(product_id:k,month_during_id:month_set.id,genre:2).first_or_initialize
        tags.tag = "#{month_label} スコア平均 ランキング##{ss}"
        tags.rank = ss
      else
        tags =Tag.where(product_id:k,month_during_id:month_set.id,genre:2).first_or_initialize
        tags.rank = ii
        tags.tag = "#{month_label} スコア平均 ランキング ##{ii}"
        ss = ii 
      end
      ii += 1 
      pre = v

      # tags.genre = 2
      tags.month_title =  month_label2
      
      tags.save
      if i == 101
        break
      end
    end
    # LIKE
    like = Like.where(updated_at: from...to).group(:product_id).order("count_all DESC").limit(100).count
    puts like

    ii = 1
    pre2 = 0
    ss = 0
    like.each do |k, v|
      puts k
      if v == pre2
        tags = Tag.where(product_id:k,month_during_id:month_set.id,genre:1).first_or_initialize
        tags.rank = ss
        tags.tag = tag:"#{month_label} お気に入り数 ランキング##{ss}"
      else
        tags =Tag.where(product_id:k,month_during_id:month_set.id,genre:1).first_or_initialize
        ss = ii 
        tags.tag = "#{month_label} お気に入り数 ランキング ##{ii}"
        tags.rank = ii
      end
      ii += 1 
      pre = v
      # tags.genre = 3
      tags.month_title =  month_label2
      
      tags.save
      if i == 101
        break
      end
    end

  end

  def all_tags_set
    # doneyet limitを調整
    Comprehensive.update_all(like: "",score:"",acsess:"")
    # @product = Product.all
    #like
    like = Like.group(:product_id).order("count_all DESC").limit(100).count
    i = 1
    pre = 0
    s = 0
    like.each do |k, v|
      puts k
        if v == pre
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.like = s
        else
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.like = i
          s = i 
        end
        com.save
        pre = v
        i += 1
    end
    # #score
    score = Score.group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(100).average(:value)
    i = 1
    pre = 0
    s = 0
    puts score
    score.each do |k, v|
      puts k
        if v == pre
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.score = s
        else
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.score = i
          s = i 
        end
        com.save
        pre = v
        i += 1
    end
    #acsess
    # acsess = Acsess.order(count: "DESC").limit(10)
    acsess = Acsess.group(:product_id).order('sum_count DESC').limit(100).sum(:count)
    # puts acsess
    i = 1
    pre = 0
    s = 0
    acsess.each do |k,v|
      # puts k
        if v == pre
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.acsess = s
        else
          com = Comprehensive.where(product_id:k).first_or_initialize
          com.acsess = i
          s = i 
        end
        com.save
        pre = v
        i += 1
    end

  end
end