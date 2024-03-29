class Api::V1::TheredsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]
  before_action :reCaptcha_check, only:[:create]

  def create
    begin
      @product = Product.find(params[:thered][:product_id])
      puts @product.thereds.where(user_id:params[:thered][:user_id]).length
      if @product.thereds.where(user_id:params[:thered][:user_id]).length>=3
        render json: {status:492}
        return
      end


      content = params[:content]
      @thered = Thered.new(reviews_params)
      @admin = User.find_by(email:"meruplanet.sub@gmail.com")
      @productThreads = @admin.thereds.left_outer_joins(:episord).where(product_id:@product.id).order('episord.episord desc').limit(4)
      @thered.question_ids
      @thered.save!
      
      render json: {status:200,thered:@thered, productThreads:@productThreads,message:{title:"「#{@product.title}」のスレッドを作成しました。",select:1}}
    rescue => e
      @EM = ErrorManage.new(controller:"review/update2",error:"#{e}".slice(0,200))
      @EM.save
      render json: {status:500}
    end
  end

  def destroy
    begin
      @review = Thered.find(params[:id])
      @review.destroy
      render json:{status:200,message:{title:"スレッドを削除しました。",select:2}}
    rescue => e
      if Thered.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"review/update2",error:"#{e}".slice(0,200))
        @EM.save
        render json: {status:500}
      else
        render json: {status:440}
      end
    end
  end

  def second
    # notest
    @product = Product.find(params[:product_id])
    render :second, formats: :json
  end

  def show
    begin
      @review = Thered.find(params[:id])
      if @review.product_id.to_s != params[:product_id]
        return render json:{status:404}
      end
      @product = @review.product
      @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)

      # 追加
      # puts"ssae"
      # puts user_signed_in?
      # puts"ssae"

      if user_signed_in?
        @user_like_review = LikeThread.find_by(thered_id:params[:id],user_id:current_user.id)
      end
      @review_length = LikeThread.where(thered_id:params[:id]).length
      @review_good = LikeThread.where(thered_id:params[:id],goodbad:1).length
      @score = @review_good / @review_length.to_f * 100

      render :show,formats: :json
    rescue => e
      if Thered.exists?(id:params[:id])
        @EM = ErrorManage.new(controller:"thered/show",error:"#{e}".slice(0,200))
        @EM.save
        render json:{status:500,e:e}
      else
        render json:{status:400}
      end
    end
  end

  def sort
    # notest
    begin
      @review = Thered.find(params[:thered_id])
      # puts params[:value]
      case params[:value]
      when "0" then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
      when "1" then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(created_at:"desc").page(params[:page]).per(5)
      when "2" then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(created_at:"asc").page(params[:page]).per(5)
      else
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_review_id) FROM like_comment_threads where like_comment_reviews.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
      end
      render :sort, formats: :json
    rescue => e
      if Thered.exists?(id:params[:thered_id])
        @EM = ErrorManage.new(controller:"thered/sort",error:"#{e}".slice(0,200))
        @EM.save
        render json:{status:500}
      else
        render json:{status:400}
      end
    end
    
  end

  # ---------------------------------------------------------------------------------
  def index
    @admin = User.find_by(email:"meruplanet.sub@gmail.com")
    # notest
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
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).where.not(user_id:@admin.id).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).group("thereds.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).group("thereds.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                when "2" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                else
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).count
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
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
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                    else
                      @reviews = Theredv.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).left_outer_joins(:acsess_threads).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                  when "3" then
                    @reviews = Thered.includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                  else
                    @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).count
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
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                else
                  @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).count
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_imageswhere(product_id:params[:product_id]).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
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
              @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from..to).page(params[:page]).per(Concerns::PAGE[:thread])
              @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from..to).count
            when "3" then
              @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).where(updated_at:from_year..to).page(params[:page]).per(Concerns::PAGE[:thread])
              @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).where(updated_at:from_year..to).count
          end
        else
          @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(product_id:params[:product_id]).page(params[:page]).per(Concerns::PAGE[:thread])
          @review_length = Thered.where.not(user_id:@admin.id).where(product_id:params[:product_id]).count
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
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).group("thereds.id").length
                    end
                when "3" then
                  case params[:range_likes_number]
                    when "1" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                    when "2" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at: from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                    else
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).group("thereds.id").length
                    end
              end
            else
              to = Time.current 
              from = to.prev_month
              from_year = to.prev_year
              from_week = to.prev_week
              case params[:range_likes_number]
                when "1" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_week..to}).group("thereds.id").length
                when "2" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).left_outer_joins(:like_threads).where(like_threads:{updated_at:from..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).left_outer_joins(:like_threads).where(like_threads:{updated_at:from_year..to}).group("thereds.id").length

                else
                  @review_length = Thered.where.not(user_id:@admin.id).count
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(Concerns::PAGE[:thread])
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
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                    when "3" then
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                    else
                      @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                      @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).left_outer_joins(:acsess_threads).count
                    end
                when "3" then
                  case params[:range_populer_number]
                  when "2" then
                    @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                  when "3" then
                    @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                  else
                    @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                    @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).count
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
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_acsess..to}).group("thereds.id").length
                when "3" then
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
                  @review_length = Thered.where.not(user_id:@admin.id).left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from_year_accsess..to}).group("thereds.id").length
                else
                  @review_length = Thered.where.not(user_id:@admin.id).count
                  @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(Concerns::PAGE[:thread])
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
              @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from..to).page(params[:page]).per(Concerns::PAGE[:thread])
              @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from..to).count
            when "3" then
              @reviews = Thered.where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.where(updated_at:from_year..to).page(params[:page]).per(Concerns::PAGE[:thread])
              @review_length = Thered.where.not(user_id:@admin.id).where(updated_at:from_year..to).count
          end
        else
          @reviews = Thered.order(created_at: :desc).where.not(user_id:@admin.id).includes(:product,:user).include_bg_images.page(params[:page]).per(Concerns::PAGE[:thread])
          @review_length = Thered.where.not(user_id:@admin.id).count
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
