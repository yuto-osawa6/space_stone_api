class Api::V1::Mainblocks::ToptensController < ApplicationController
  def index
  end

  def topten_l
    @like_topten_all = Product.with_attached_bg_images.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).year_season_scope.where.not(likes:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC'))
    @scores = Score.where(product_id:@like_topten_all.ids).group("product_id").average_value
    render :topten_l  ,formats: :json
  end

  def topten_lm
    now = Time.current 
    from = now.prev_month
    to = now
    @like_topten_month =  Product.with_attached_bg_images.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).year_season_scope.where.not(likes:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)
    @like = Like.where(product_id:@like_topten_month.ids,updated_at: from...to).group("product_id").count
    @scores = Score.where(product_id:@like_topten_month.ids).group("product_id").average_value
    render :topten_lm  ,formats: :json
  end

  def topten_a
    @acsess_topten_all = Product.with_attached_bg_images.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).year_season_scope.where.not(acsesses:{id:nil}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC')).limit(10)
    @acsess = Acsess.where(product_id:@acsess_topten_all.ids).group("product_id").sum(:count)
    @scores = Score.where(product_id:@acsess_topten_all.ids).group("product_id").average_value

    render :topten_a  ,formats: :json
  end
  def topten_am
    now = Time.current 
    from = now.prev_month
    to = now
    @acsess_topten_month = Product.with_attached_bg_images.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).year_season_scope.where(acsesses:{date:Time.current.prev_month.beginning_of_month...to}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC')).limit(10)
    @acsess = Acsess.where(product_id:@acsess_topten_month.ids,updated_at: Time.current.prev_month.beginning_of_month...to).group("product_id").sum(:count)
    @scores = Score.where(product_id:@acsess_topten_month.ids).group("product_id").average_value
    render :topten_am  ,formats: :json
  end
  def topten_s
    @score_topten_all = Product.with_attached_bg_images.left_outer_joins(:scores).includes(:styles,:janls,:scores).year_season_scope.where.not(scores:{value:nil}).group("products.id").order(Arel.sql('avg(scores.value) DESC')).order(id: :asc).limit(10)
    @scores = Score.where(product_id:@score_topten_all.ids).group("product_id").average_value
    render :topten_s  ,formats: :json
  end
  def topten_sm
    now = Time.current 
    from = now.prev_month
    to = now
    @score_topten_month = Product.with_attached_bg_images.left_outer_joins(:scores).includes(:styles,:janls,:scores).year_season_scope.where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(scores.value) DESC')).order(id: :asc).limit(10)
    @scores = Score.where(product_id:@score_topten_month.ids,updated_at: from...to).group("product_id").average_value
    render :topten_sm ,formats: :json
  end
  def topten_r
    @review_topten_all = Product.with_attached_bg_images.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).year_season_scope.where.not(reviews:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)
    @scores = Score.where(product_id:@review_topten_all.ids).group("product_id").average_value
    @like = Review.where(product_id:@review_topten_all.ids).group("product_id").count

    render :topten_r  ,formats: :json
  end
  def topten_rm
    now = Time.current 
    from = now.prev_month
    to = now
    @review_topten_month = Product.with_attached_bg_images.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).year_season_scope.where(reviews:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)
    @scores = Score.where(product_id:@review_topten_month.ids,updated_at: from...to).group("product_id").average_value
    @like = Review.where(product_id:@review_topten_month.ids,updated_at: from...to).group("product_id").count
    render :topten_rm  ,formats: :json
  end
end