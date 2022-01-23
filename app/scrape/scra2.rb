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

  def ota
    l = "2時間30分"
    b = "30分"
    c = "11時間"

    puts a = l.match(/分/).pre_match.split(/s*時間s*/)[1]
    # puts aa = c.match(/時間/).pre_match
    # puts b.match(/時間/).pre_match
    # puts "%02d" % aa.to_i

    ll = "12:00:00"
    # puts ll.to_time
    # puts l.include?("時間")



  end
end