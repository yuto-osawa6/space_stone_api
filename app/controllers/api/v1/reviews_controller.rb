class Api::V1::ReviewsController < ApplicationController
  before_action :check_user_logined, only:[:create,:update,:update2,:destroy]
  before_action :reCaptcha_check, only:[:create,:update,:update2]

  # before_action :authenticate_user!, only:[:show]
  # before_action :authenticate_user!
  def create 
    begin
      if params[:review][:episord_id]=="null"
        params[:review][:episord_id]=nil
      end
      review  = Review.new(reviews_params)
      emotionArray = []
      params[:review][:emotion_ids].each do |i|
        # ,review_id:params[:review][:review_id] check-1消した
        emotion = ReviewEmotion.new(review_id:review.id,product_id:params[:review][:product_id],episord_id:params[:review][:episord_id],emotion_id:i,user_id:params[:review][:user_id])
        emotionArray << emotion
      end
      review.review_emotions = emotionArray
      if review.save
        @userReview = Review.where(product_id:params[:review][:product_id],user_id:params[:review][:user_id])
        @product = Product.find(params[:review][:product_id])
        @productReviews = @product.reviews.includes(:like_reviews).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).limit(4)


        @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
        @emotionList.count
        render :create, formats: :json
      else
        if Review.exists?(product_id:params[:review][:product_id],user_id:params[:review][:user_id],episord_id:params[:review][:episord_id])
          render json: { status: 450 } 
        else
          render json: { status: 440 } 
        end
      end
    rescue => e
      @EM = ErrorManage.new(controller:"review/create",error:"#{e}".slice(0,200))
      @EM.save
      render json: {status:500}
    end
  end

  def update
    begin
      if params[:review][:episord_id]=="null"
        params[:review][:episord_id]=nil
      end
      review = Review.find(params[:id])
    # emotion
      emotionArray = []
      params[:review][:emotion_ids].each do |i|
        emotion = ReviewEmotion.where(product_id:params[:review][:product_id],review_id:review.id,episord_id:params[:review][:episord_id],emotion_id:i,user_id:params[:review][:user_id]).first_or_initialize
        if emotion.save!
          emotionArray << emotion
        else
          render json: {status:500}
          return
        end
      end
      review.review_emotions = emotionArray
      if review.update(reviews_params)
        @userReview = Review.where(product_id:params[:review][:product_id],user_id:params[:review][:user_id])
        @product = Product.find(params[:review][:product_id])
        @productReviews = @product.reviews.includes(:like_reviews).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).limit(4)
        @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
        @emotionList.count
        render :update, formats: :json
      else
        render json: {status:440}
      end
    rescue => e
      if Review.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"review/update",error:"#{e}".slice(0,200))
        @EM.save
        render json: {status:500}
      else
        render json: {status:460}
      end
    end
  end

  def update2
    begin
      if params[:review][:episord_id]=="null"
        params[:review][:episord_id]=nil
      end
      puts Review.exists?(id:params[:id])
      puts Review.exists?(id:params[:id].to_i)
      puts params[:id]

      @review = Review.find(params[:id])
      puts "aaa"
      emotionArray = []
      params[:review][:emotion_ids].each do |i|
        emotion = ReviewEmotion.where(product_id:params[:review][:product_id],review_id:@review.id,episord_id:params[:review][:episord_id],emotion_id:i,user_id:params[:review][:user_id]).first_or_initialize
        puts emotion.inspect
        if emotion.save!
          emotionArray << emotion
        else
          render json: {status:500}
          return
        end
      end
      @review.review_emotions = emotionArray
      if @review.update(reviews_params)
        render :update2, formats: :json
      else
        render json: {status:440}
      end
    rescue => e
      if Review.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"review/update",error:"#{e}".slice(0,200))
        @EM.save
        render json: {status:500}
      else
        render json: {status:460}
      end
    end
  end

  def second
    # notest
    @userReview = Review.where(product_id:params[:product_id],user_id:params[:user_id])
    @product = Product.find(params[:product_id])
    @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
    render :second, formats: :json
  end

  def destroy
    begin
      @review = Review.find(params[:id])
      @review.destroy
      render json:{status:200,message:{title:"レビューを削除しました。",select:2}}
    rescue => e
      if  Review.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"review/destroy",error:"#{e}".slice(0,200))
        @EM.save
        render json:{status:500}  
      else
        render json:{status:440}  
      end
    end
    puts params
  end

  def show
    begin
      @review = Review.includes(:like_reviews,:emotions).find(params[:id])
      if @review.product_id.to_s != params[:product_id]
        return render json:{status:404}
      end
      @product = @review.product
      @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)

      # 追加
      if user_signed_in?
        @user_like_review = LikeReview.find_by(review_id:params[:id],user_id:current_user.id)
      end
      @review_length = LikeReview.where(review_id:params[:id]).length
      @review_good = LikeReview.where(review_id:params[:id],goodbad:1).length
      @score = @review_good / @review_length.to_f * 100

      if !@review.episord.blank?
        # puts "aooioi"
        @episord = @review.episord.episord
        @episordTitle = @review.episord.title
      else
        @episord = nil
        @episordTitle = nil
      end
      # @episord = nil
      # @episordTitle = nil

      render :show,formats: :json
    rescue => e
      if Review.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"review/show",error:"#{e}".slice(0,200))
        @EM.save
        render json:{status:500}
      else
        render json:{status:400}
      end
    end
  end

  def sort
    # notest
    begin
      @review = Review.find(params[:review_id])
      case params[:value]
      when "0" then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)
      when "1" then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"desc").page(params[:page]).per(5)
      when "2" then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"asc").page(params[:page]).per(5)
      else
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(params[:page]).per(5)
      end
      render :sort, formats: :json
    rescue => e
      if Review.exists?(id:params[:review_id])
        @EM = ErrorManage.new(controller:"review/sort",error:"#{e}".slice(0,200))
        @EM.save
        render json:{status:500}
      else
        render json:{status:400}
      end
    end
  end
  # ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
  def index
    # notest
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
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.where(product_id:params[:product_id]).length
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.where(product_id:params[:product_id]).length
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
              @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).length
            when "3" then
              @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:like_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
              @reviews = Review.includes(:product,:user).include_bg_images.where(updated_at:from..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(updated_at:from..to).length
            when "3" then
              @reviews = Review.includes(:product,:user).include_bg_images.where(updated_at:from_year..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.includes(:product,:user).include_bg_images.page(params[:page]).order(created_at: :desc).per(Concerns::PAGE[:review])
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
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.includes(:product,:user).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                  @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
              @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
            when "3" then
              @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
          end
        else
          @reviews = Review.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
                  @reviews = Review.left_outer_joins(:like_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:review])
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
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).length
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_review,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
                  @review_length = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).count
                  @reviews = Review.left_outer_joins(:acsess_reviews,:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:review])
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
              @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(updated_at:from..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from..to).length
            when "3" then
              @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).page(params[:page]).per(Concerns::PAGE[:review])
              @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(updated_at:from_year..to).length
          end
        else
          @reviews = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).includes(:product,:user).include_bg_images.page(params[:page]).per(Concerns::PAGE[:review])
          @review_length = Review.left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
        end
      end
    end
  end

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id,:score)
    # params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id,:review_emotions)

  end
  # def reviews_params2
  #   params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id)
  #   # params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id,:review_emotions)

  # end
end
