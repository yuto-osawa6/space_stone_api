class Api::V1::TheredsController < ApplicationController
  def create 
    content = params[:content]
    # thered.thered_question_questions.build

    @thered = Thered.new(reviews_params)
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    # puts params[:question_ids]
    puts params[:text]
    # puts Thered.find(8).questions[0].thered_quesitons.ids
    @thered.question_ids
    puts "jkh"

    # thered.thered_question_questions.build
    if @thered.save
      render json: {thered:@thered}
    else
      render json: {status:500,thered:@thered}
    end
  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Thered.find(params[:id])
    @product = @review.product
    @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC'))

    render :show,formats: :json
  end

  def sort
    @review = Thered.find(params[:thered_id])
    # puts params[:value]
    case params[:value]
    when "0" then
      @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC'))
    when "1" then
      @review_comments = @review.comment_threads.order(created_at:"desc")
    when "2" then
      @review_comments = @review.comment_threads.order(created_at:"asc")
    else
      @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_review_id) FROM like_comment_threads where like_comment_reviews.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC'))
    end
    render :sort, formats: :json
  end

  # ---------------------------------------------------------------------------------
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
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).group("thereds.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).group("thereds.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                when "2" then
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                else
                  @review_length = Thered.where(product_id:params[:product_id]).count
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                    else
                      @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                  when "3" then
                    @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                  else
                    @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).count
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
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Thered.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Thered.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                else
                  @review_length = Thered.where(product_id:params[:product_id]).count
                  @reviews = Thered.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
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
              @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from..to).count
            when "3" then
              @reviews = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).count
          end
        else
          @reviews = Thered.where(product_id:params[:product_id]).page(params[:page]).per(2)
          @review_length = Thered.where(product_id:params[:product_id]).count
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
                      @reviews = Thered.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where(updated_at: from..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).group("thereds.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Thered.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where(updated_at:from_year..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from_year..to).group("thereds.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                when "2" then
                  @reviews = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
                  @review_length = Thered.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                else
                  @review_length = Thered.count
                  @reviews = Thered.left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
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
                      @reviews = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                    else
                      @reviews = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                      @review_length = Thered.where(updated_at:from..to).left_outer_joins(:acsess_threads).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Thered.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                  when "3" then
                    @reviews = Thered.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                  else
                    @reviews = Thered.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                    @review_length = Thered.where(updated_at:from_year..to).count
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
                  @reviews = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
                  @review_length = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                else
                  @review_length = Thered.count
                  @reviews = Thered.left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
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
              @reviews = Thered.where(updated_at:from..to).page(params[:page]).per(2)
              @review_length = Thered.where(updated_at:from..to).count
            when "3" then
              @reviews = Thered.where(updated_at:from_year..to).page(params[:page]).per(2)
              @review_length = Thered.where(updated_at:from_year..to).count
          end
        else
          @reviews = Thered.page(params[:page]).per(2)
          @review_length = Thered.count
        end
      end
    end
    render :index,formats: :json
  end


  private 
  def reviews_params
    params.require(:thered).permit(:title,:discribe,:content,:user_id,:product_id, question_ids:[])
  end
end
