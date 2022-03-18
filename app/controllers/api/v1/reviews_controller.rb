class Api::V1::ReviewsController < ApplicationController
  def create 
    content = params[:content]
    if params[:review][:episord_id]=="null"
      params[:review][:episord_id]=nil
    end

    review  = Review.new(reviews_params)

    # emotion
    # begin
    emotionArray = []
    params[:review][:emotion_ids].each do |i|
      emotion = ReviewEmotion.new(review_id:review.id,product_id:params[:review][:product_id],review_id:params[:review][:review_id],episord_id:params[:review][:episord_id],emotion_id:i,user_id:params[:review][:user_id])
      # emotion.save!
      emotionArray << emotion
    end
    review.review_emotions = emotionArray


   begin
    if review.save!
      @userReview = Review.where(product_id:params[:review][:product_id],user_id:params[:review][:user_id])
      @product = Product.find(params[:review][:product_id])
      @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
      @emotionList.count
      render :create, formats: :json

    else
      render json: {status:500,review:review}
    end

    rescue => e
      render json: {status:500,review:review}
    end
  end

  def update

    content = params[:content]
    if params[:review][:episord_id]=="null"
      params[:review][:episord_id]=nil
    end

    # review  = Review.new(reviews_params)
    review = Review.find(params[:id])

    # emotion
    begin
    emotionArray = []
    params[:review][:emotion_ids].each do |i|
      emotion = ReviewEmotion.where(product_id:params[:review][:product_id],review_id:review.id,episord_id:params[:review][:episord_id],emotion_id:i,user_id:params[:review][:user_id]).first_or_initialize
      puts emotion.inspect
      emotion.save!
      emotionArray << emotion
    end
    review.review_emotions = emotionArray


  #  begin
    if review.update(reviews_params)
      @userReview = Review.where(product_id:params[:review][:product_id],user_id:params[:review][:user_id])
      @product = Product.find(params[:review][:product_id])
      @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
      @emotionList.count

      render :update, formats: :json
    else
      render json: {status:500,review:review}
    end

    rescue => e
      render json: {status:500,review:review}
    end

  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Review.includes(:like_reviews,:emotions).find(params[:id])
    @product = @review.product

    @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)


    

    render :show,formats: :json
  end

  def sort
    @review = Review.find(params[:review_id])
    puts params[:value]
    case params[:value]
    when "0" then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)
    when "1" then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"desc").page(params[:page]).per(5)
    when "2" then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"asc").page(params[:page]).per(5)
    else
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)
    end
    render :sort, formats: :json
  end
  # ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
  def index
  if params[:emotion].present?
    emotion()
  else
    if params[:product_id].present?
      if params[:select_sort].present?
        case params[:select_sort]
          when "0" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_number]
                when "2" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).group("reviews.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.where(product_id:params[:product_id]).length
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
              end
            end
          when "1" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_number]
                when "2" then
                  case params[:range_populer_number]
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).length
                  end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_populer_number]
                when "2" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.where(product_id:params[:product_id]).length
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                end
          end
        end
      else
        if params[:range_number].present?
          
          to = Time.current 
          from = to.prev_month
          from_year = to.prev_year
          case params[:range_number]
            when "2" then
              @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).length
            when "3" then
              @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).page(params[:page]).per(2)
          @review_length = Review.where(product_id:params[:product_id]).length
        end
      end
      
    else
      if params[:select_sort].present?
        case params[:select_sort]
          when "0" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_number]
                when "2" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).group("reviews.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
              end
            end
          when "1" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_number]
                when "2" then
                  case params[:range_populer_number]
                    when "2" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).count
                  end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_populer_number]
                when "2" then
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                end
          end
        end
      else
        if params[:range_number].present?
          
          to = Time.current 
          from = to.prev_month
          from_year = to.prev_year
          case params[:range_number]
            when "2" then
              @reviews = Review.includes(:product,:user).where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Review.where(updated_at:from..to).length
            when "3" then
              @reviews = Review.includes(:product,:user).where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Review.where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.includes(:product,:user).page(params[:page]).order(created_at: :desc).per(2)
          @review_length = Review.count
        end
      end
    end
  end
    render :index,formats: :json
  end







  # -------------------------------------------------------------------------------


  def emotion
    puts "000000000000000"
    if params[:product_id].present?
      if params[:select_sort].present?
        case params[:select_sort]
          when "0" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_number]
                when "2" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
              end
            end
          when "1" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_number]
                when "2" then
                  case params[:range_populer_number]
                    when "2" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                  end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_populer_number]
                when "2" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                  @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                end
          end
        end
      else
        if params[:range_number].present?
          
          to = Time.current 
          from = to.prev_month
          from_year = to.prev_year
          case params[:range_number]
            when "2" then
              @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
            when "3" then
              @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
          end
        else
          @reviews = Review.includes(:product,:user).where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(2)
          @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
        end
      end
      
    else
      if params[:select_sort].present?
        case params[:select_sort]
          when "0" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_number]
                when "2" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
              end
            end
          when "1" then
            if params[:range_number].present?
              # @today =Date
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_number]
                when "2" then
                  case params[:range_populer_number]
                    when "2" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from_year..to).count
                  end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_acsess = to.beginning_of_month
              from_year_accsess = to.beginning_of_year
              case params[:range_populer_number]
                when "2" then
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).count
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                end
          end
        end
      else
        if params[:range_number].present?
          
          to = Time.current 
          from = to.prev_month
          from_year = to.prev_year
          case params[:range_number]
            when "2" then
              @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from..to).length
            when "3" then
              @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).page(params[:page]).per(2)
          @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
        end
      end
    end
  end

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id)
    # params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id,:review_emotions)

  end
end
