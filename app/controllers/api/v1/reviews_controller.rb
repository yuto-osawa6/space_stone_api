class Api::V1::ReviewsController < ApplicationController
  def create 
    content = params[:content]
    review  = Review.new(reviews_params)
    if review.save
      render json: {review:review}
    else
      render json: {status:500,review:review}
    end
  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Review.find(params[:id])
    @product = @review.product
    @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))

    # puts @review_comments
    # .order((Arel.sql("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id")) "desc")
    # .find(LikeCommentReview.group(:comment_review_id).order("count(comment_review_id) desc").plunk(:comment_review_id))
    # .find([2,3,4])
    # .find(LikeCommentReview.group(:comment_review_id).order("count(comment_review_id) desc").plunk(:comment_review_id))
    # .order(Arel.sql("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id"))
    # .joins(:like_comment_reviews).group("comment_review_id").order(Arel.sql('count(comment_review_id) DESC'))
    
    # order("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id")

    # likecheck
      # @user = User.find(params[:user_id])
      # @like_review = LikeReview.find_by(user_id:params[:user_id])


    render :show,formats: :json
  end

  def sort
    @review = Review.find(params[:review_id])
    puts params[:value]
    case params[:value]
    when "0" then
      @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    when "1" then
      @review_comments = @review.comment_reviews.order(created_at:"desc")
    when "2" then
      @review_comments = @review.comment_reviews.order(created_at:"asc")
    else
      @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    end
    render :sort, formats: :json
  end
  # ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
  def index
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
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.where(product_id:params[:product_id]).count
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_reviews).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).count
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
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.where(product_id:params[:product_id]).count
                  @reviews = Review.where(product_id:params[:product_id]).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
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
              @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from..to).count
            when "3" then
              @reviews = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Review.where(product_id:params[:product_id]).where(updated_at:from_year..to).count
          end
        else
          @reviews = Review.where(product_id:params[:product_id]).page(params[:page]).per(2)
          @review_length = Review.where(product_id:params[:product_id]).count
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
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at: from..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).group("reviews.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                    when "2" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at: from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                    else
                      @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                  @reviews = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_week..to}).group("reviews.id").length
                when "2" then
                  @reviews = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:like_reviews).where(like_reviews:{updated_at:from_year..to}).group("reviews.id").length

                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                    when "3" then
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                    else
                      @reviews = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Review.where(updated_at:from..to).left_outer_joins(:acsess_reviews).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                  when "3" then
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                  else
                    @reviews = Review.where(updated_at:from_year..to).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
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
                  @reviews = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_acsess..to}).group("reviews.id").length
                when "3" then
                  @reviews = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from_year_accsess..to}).group("reviews.id").length
                else
                  @review_length = Review.count
                  @reviews = Review.left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
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
              @reviews = Review.where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Review.where(updated_at:from..to).count
            when "3" then
              @reviews = Review.where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Review.where(updated_at:from_year..to).count
          end
        else
          @reviews = Review.page(params[:page]).per(2)
          @review_length = Review.count
        end
      end
    end
    render :index,formats: :json
  end

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id)
  end
end
