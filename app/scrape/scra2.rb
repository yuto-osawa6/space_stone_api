class Scra2
  def War
    # @a = ReturnCommentReview.find(12)
    # @b = ReturnCommentThread.find(1)
    # ReturnCommentReview.where(comment_review_id:)
    # puts @a.return_return_comment_reviews.ids
    # if @a.return_returns[0].present?
    # puts @a.return_returns[0].user.id
    # end
    # puts @a.reverse_of_return_return_comment_reviews.ids
    # puts @a.rereturn_returns.ids

    # puts @b.return_return_comment_threads.ids


    # @a = ReturnCommentReview.find(31)
    # puts @a.rereturn_returns.ids

    # @b = ReturnCommentThread.find(2)

    # puts @b.rereturn_returns.ids
    # @user = User.find(4)
    # @user.administrator_gold = true
    # @user.save

  end

  def split_during
    # doneyet(変更後試してない。)
    @product = Product.where("duration LIKE ?", "%シーズン%")
    @product.each do |pp|
      pp.season = pp.duration.delete("シーズン").to_i
      pp.save
    end
    
  end

  def split_during
    # doneyet(変更後試してない。)
    @product = Product.where("duration LIKE ?", "%シーズン%").or(Product.where("duration LIKE ?", "%パート%")).or(Product.where("duration LIKE ?", "%シリーズ%")).or(Product.where("duration LIKE ?", "%コレクション%"))
    @product.each do |pp|
      pp.season = pp.duration.delete("シーズンパトリコレクショ").to_i
      pp.save
    end
    
  end

  def split_during_time
    # doneyet(変更後試してない。)
    @product = Product.where("duration LIKE ?", "%時間%").or(Product.where("duration LIKE ?", "%分%"))
    @product.each do |pp|
      if pp.duration.include?("時間")
        @h = pp.duration.match(/時間/).pre_match
        @h = "%02d" % @h.to_i 
      else
        @h = "00"
      end

      if pp.duration.include?("分")
        if pp.duration.include?("時間")
          @m = pp.duration.match(/分/).pre_match.split(/s*時間s*/)[1]
          @m = "%02d" % @m.to_i
        else
          @m = pp.duration.match(/分/).pre_match.split(/s*時間s*/)[0]
          @m = "%02d" % @m.to_i
        end
      else
        @m = "00"
      end
      time = "#{@h}:#{@m}:00"
      # puts time
      pp.time = time
      pp.save
    end
    
  end

  def year_set
    @product = Product.where("length(year) = 4")
    # puts @product.length
    @product.each do |pp| 
      pp.year2 = "#{pp.year}0101"
      pp.save
    end
  end

  def Change_season_to_number_type
    @season = Season.all
    @season.each do |e|
      e.season_number = e.season.gsub(/[^\d]/, "")
      e.save
    end
  end

  def ota
    # l = "2時間30分"
    # b = "30分"
    # c = "11時間"

    # puts a = l.match(/分/).pre_match.split(/s*時間s*/)[1]
    # puts aa = c.match(/時間/).pre_match
    # puts b.match(/時間/).pre_match
    # puts "%02d" % aa.to_i

    # ll = "12:00:00"
    # puts ll.to_time
    # puts l.include?("時間")

    # @product = Product.where(year2:"1945-01-01")
    # puts @product.length

    # today = Date.current
    # puts today
    # @score_topten_all = Product.joins(:scores).group("product_id").order(Arel.sql('avg(value) DESC')).limit(10)
    # puts @score_topten_all
    # @article = Article.find(12)
    # puts @article.products

    article = Review.where(article_id:12)
    # puts ArticleProduct.where(product_id:article.pluck(:product_id)).group(:article_id).pluck(:article_id)
    # puts ArticleProduct.where(product_id:article.pluck(:product_id)).group(:article_id).order("count(article_id) desc").pluck(:article_id)
    # puts Article.joins(:article_products).where(article_products: { product_id: article.pluck(:product_id) }).group(:article_id).order("count(article_id) desc")


    # @score_topten_all = Product.joins(:scores).group("product_id").order(Arel.sql('avg(value) DESC')).limit(10)

    # order 複数の設定方法
    # doneyet (leftjoinsでgroup orderできるのか)
    # puts Review.joins(:like_reviews).group(:review_id).order("Count(goodbad) desc",created_at: :desc).count
    # puts Review.all.length
    # Review.includes(:like_reviews).sort_by{|x| x.like_reviews.size}.pluck(:id)

    # puts Review.includes(:like_reviews).group("like_reviews")
  #  Review.left_outer_joins(:like_reviews).select("like_reviews", "100.0 * COUNT(*) / (SELECT COUNT(*) FROM surveys) as rate").group("reviews.id").order("count(review_id) desc").pluck(:id)

    # puts Review.left_joins(:like_reviews).where(goodbad:1)


    # Review.left_outer_joins(:like_reviews).select("like_reviews, COUNT(*) / (SELECT COUNT(*) FROM surveys) as rate").group("reviews.id").order("(count(review_id)/count(review_id)) desc").pluck(:id)
    
    # Review.left_outer_joins(:like_reviews).order("goodbad desc")

    # Review.left_outer_joins(:like_reviews).select("reviews,like_reviews.goodbad==1").group("reviews.id").order("like_reviews.goodbad=1 desc")
    # LikeReview.all.order("goodbad=1 desc")

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").having("count(goodbad=?)",2).pluck(:id)

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").having("count(goodbad=?)",2).pluck(:id)

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").order("count(goodbad=?),2").pluck(:id)

    # sql = 100.0 * CASE WHEN pickup = '1' THEN 1 ELSE 0 END / (*) AS bad

    # puts Product.order('case when pickup = 1 then 0 else 1 end',"desc")


    # arel.sqlが必要だった
    # puts Product.order(Arel.sql("'id' = CASE WHEN id = 3 THEN 0 ELSE 'id' END")).order("id desc").all

    # puts LikeReview.order(Arel.sql("'goodbad' = CASE WHEN goodbad = 1 THEN 1 ELSE 0 END")).order("goodbad desc").ids

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("'goodbad' = CASE WHEN like_reviews.goodbad = 1 THEN 1 ELSE 0 END")).order("sum(goodbad) desc")


    # puts LikeReview.order(Arel.sql("(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END) desc")).ids

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("count(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END) desc")).ids

    # puts Review.left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END) desc")).ids

    # puts Review.left_outer_joins(:like_reviews).order(Arel.sql("(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/(CASE WHEN goodbad = 1 THEN 1 ELSE 1 END) desc")).ids


    # これが正解
    puts Review.left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").ids


    # acsess
    puts  Review.left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).ids

    to = Time.current 
    from = to.prev_month
    from_year = to.prev_year

    # puts Review.where(updated_at:from..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").ids

    # puts Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").ids

    # puts Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").count
    
    # puts Review.where(updated_at:a)

    # puts Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to})
  end

  def ota3
    @user = User.find(4)
    # puts url_for(@user.bg_img)
    puts @user.image_url
    # puts rails_storage_proxy_path(@user.bg_img)
  end

  def ota4
    @user = User.find(4)
    # il= @user.liked_products.joins(:janl_products).group(:janl_id).order("count(janl_id) desc").count.keys

    # # Product.janls
    # Janl.where(id:il).order([Arel.sql('field(id, ?)'), il]).ids

    # puts @user.scores.group(:value).count

    # @user.liked_products

    # 
    # @user.scores_products.joins(:scores).order(Arel.sql('products')).count
    # puts @user.scores_products.joins(:scores).where(scores:{user_id:4}).ids

    # Product.joins(:scores).where(scores:{user_id:4}).order(value: :desc).each do |a|
    #   print a.scores.where(scores:{user_id:4})[0].value
    #   # print @user.scores.
    # end
    # Score.where(product_id:11,user_id:@user.id)[0].value

    # Product.joins(:scores).where(scores:{user_id:4}).ids

    # ^^^^^^^^^^^^^^^^^^^^^^^^^^
    # puts Product.find(3429).delivery_start?
    
    # puts Date.today > Product.find(3429).delivery_start

    # Product.all.includes(:tags).each do |acsess|
    #     # acsess.tags.limit(3)
    # end

    # pp = Product.where(id:1...20).tags.limit(10)

    now = Time.current
    from = now.ago(3.month).beginning_of_month
    to = now.since(3.month).end_of_month
    @delivery_end = Product.where(delivery_end:from...to)
  end

  def ota5
    now = Time.current 
    from = now.prev_month
    to = now
    # @like_topten_month =  Product.joins(:likes).where(likes:{updated_at: from...to}).pluck(:id)
    # @like_topten_month =  Product.joins(:likes).where(likes:{updated_at: from...to}).group("product_id").order(Arel.sql('count(product_id) DESC')).limit(10).each do |a|
    #   puts a.likes.count
    # end
    # @acsess_topten_month = Product.joins(:acsesses).where(acsesses:{date:Time.current.prev_month.beginning_of_month...to}).group("product_id").order(Arel.sql('sum(count) DESC')).limit(10).ids
    # Product.joins(:scores).group("product_id").order(Arel.sql('avg(value) DESC')).limit(10)
    # @like_topten_month = Product.joins(:likes).where(updated_at:from...to).group("product_id").order(Arel.sql('count(product_id) DESC')).limit(10)

    # @score_topten_month = Product.joins(:scores).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).limit(10).ids
    #  -@score_topten_month = Product.left_outer_joins(:scores).includes(:styles,:janls,:scores).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).order(id: :asc).limit(10).each do |a|
    #   puts a.id
    # end

    # -@acsess_topten_month = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where(acsesses:{date:Time.current.prev_month.beginning_of_month...to}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10).each do |a|
    #  puts a.id 
    # end
    puts "aa"

    # -@acsess_topten = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10).each do |a|
    #   puts a.acsesses
    #   # .where(date:Time.current.prev_month.beginning_of_month...to)
    #  end
     @review_topten_all = Product.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where.not(reviews:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10).ids
  end

  def ota6
    to = Time.current 
    from = to.prev_month
    # @season = Season.where("length(season) = 13").order(season:"asc")
    @season = Season.order(season:"asc").ids
    Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).limit(5).ids

  end

  def ota7
    # ReviewComment.where(review_id:3).like_comment_reviews 
    # puts 2/12.to_f*100
    puts "aaa".encode("UTF-8").bytesize

  end

  
end