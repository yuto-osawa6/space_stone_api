class Api::V1::Mainblocks::MainsController < ApplicationController
  def new_netflix
    @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).includes(:styles,:janls,:tags,:scores).order(delivery_start:"desc")
    render :new_netflix,formats: :json
  end

  def pickup
    @pickup = Product.where(pickup:true).includes(:styles,:janls,:tags,:scores)
    render :pickup,formats: :json
  end

  def new_message
    # puts params[:active] == 0
    if params[:active] == "0"
      @new_message = Newmessage.all.order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.all.count
    elsif params[:active] == "1"
      @new_message = Newmessage.where(judge:1).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:1).count
    elsif params[:active] == "2"
      @new_message = Newmessage.where(judge:2).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:2).count
    elsif params[:active] == "3"
      @new_message = Newmessage.where(judge:3).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:3).count
    end
    render :new_message,formats: :json
  end

  def calendar
    # @delivery_end = Product.where("length(delivery_end) > 0")
    # @delivery_start = Product.where("length(delivery_start) > 0")
    # today = Date.today
    now = Time.current
    from = now.ago(3.month).beginning_of_month
    to = now.since(2.month).end_of_month
    @delivery_end = Product.where(delivery_end:from...to).includes(:styles,:janls,:tags,:scores)
    @delivery_start = Product.where(delivery_start:from...to).includes(:styles,:janls,:tags,:scores)
    render :calendar,formats: :json
  end

  def worldclass
    @period = Period.order(created_at:"desc").limit(1)
    @topten = @period[0].toptens.where.not(product_id:nil).includes(product: :styles).includes(product: :janls).includes(product: :scores)
    render :worldclass,formats: :json
  end

  def toptens
     # top10
     now = Time.current 
     from = now.prev_month
     to = now
    #  @like_topten_month =  Like.where(updated_at: from...to).group(:product_id).order("count_all DESC").limit(10).count
    #  @like_topten_all =  Like.group(:product_id).order("count_all DESC").limit(10).count
    #  @score_topten_month = Score.where(updated_at: from...to).group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(10).average(:value)
    #  @score_topten_all = Score.group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(10).average(:value)
    #  @acsess_topten_month = Acsess.where(date: Time.current.prev_month.beginning_of_month...to).group(:product_id).order("sum_count DESC").limit(10).sum(:count)
    #  @acsess_topten_all = Acsess.group(:product_id).order('sum_count DESC').limit(10).sum(:count)

     @like_topten_month =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(10)
     @like_topten_all =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where.not(likes:{id:nil}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(10)
     @score_topten_month = Product.left_outer_joins(:scores).includes(:styles,:janls,:scores).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).order(id: :asc).limit(10)
     @score_topten_all = Product.left_outer_joins(:scores).includes(:styles,:janls,:scores).where.not(scores:{value:nil}).group("products.id").order(Arel.sql('avg(value) DESC')).order(id: :asc).limit(10)
     @acsess_topten_month = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where(acsesses:{date:Time.current.prev_month.beginning_of_month...to}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10)
     @acsess_topten_all = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where.not(acsesses:{id:nil}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10)

     @review_topten_month = Product.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where(reviews:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)
     @review_topten_all = Product.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where.not(reviews:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)

     render :toptens,formats: :json
  end

  def populur_rt
    # doneyet_3 正確な月間ではない
    to = Time.current 
    from = to.prev_month

    @popular_reviews = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).limit(6)
    @popular_threads = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).limit(6)
    render :populur_rt,formats: :json
  end
end