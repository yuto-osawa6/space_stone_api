class Api::V1::Mainblocks::MainsController < ApplicationController
  def new_netflix
    current = Time.current

    case current.month
      when 1,2,3 then
        @kisetsu = 5
        @kisetsu_name = "冬"
      when 4,5,6 then
        @kisetsu = 2
        @kisetsu_name = "春"
      when 7,8,9 then
        @kisetsu = 3
        @kisetsu_name = "夏"
      when 10,11,12 then
        @kisetsu = 4
        @kisetsu_name = "秋"
    end

    year = Year.find_by(year:"#{current.year}-01-01")
    season = Kisetsu.find_by(name:@kisetsu_name)
    @current_season = "#{current.year} #{season.name}"
    @new_netflix = Product.with_attached_bg_images.where(finished:1).left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls).year_season_scope.where(year_season_years:{year:"#{current.year}-01-01"}).where(year_season_seasons:{id:season.id}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC'))
    @scores = Score.where(product_id:@new_netflix.ids).group("product_id").average_value

    # tierGroup = TierGroup.find_by(year_id:year.id,kisetsu_id:season.id)
    # # doneyet-3 (orderがfrontに送られたときにid順になる問題)
    # if tierGroup.present?
    #   @tier = tierGroup.tiers.includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    #   @tier_p = tierGroup.products.with_attached_bg_images.where(finished:1).includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc"))
    # else
     
    # end
   
    render :new_netflix,formats: :json
  end

  def pickup
    current = Time.current.ago(3.month)
    current2 = Time.current.since(3.month)

    case current.month
    when 1,2,3 then
      @kisetsu = 5
      @kisetsu_name = "冬"
    when 4,5,6 then
      @kisetsu = 2
      @kisetsu_name = "春"
    when 7,8,9 then
      @kisetsu = 3
      @kisetsu_name = "夏"
    when 10,11,12 then
      @kisetsu = 4
      @kisetsu_name = "秋"
  end

    case current2.month
    when 1,2,3 then
      @kisetsu2 = 5
      @kisetsu_name2 = "冬"
    when 4,5,6 then
      @kisetsu2 = 2
      @kisetsu_name2 = "春"
    when 7,8,9 then
      @kisetsu2 = 3
      @kisetsu_name2 = "夏"
    when 10,11,12 then
      @kisetsu2 = 4
      @kisetsu_name2 = "秋"
  end
    year = Year.find_by(year:"#{current.year}-01-01")
    season = Kisetsu.find_by(name:@kisetsu_name)
    season2 = Kisetsu.find_by(name:@kisetsu_name2)

    @current_season = "#{current.year} #{Kisetsu.find(@kisetsu).name}"
    @pickup = Product.with_attached_bg_images.where(finished:1).left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls).year_season_scope.where(year_season_years:{year:"#{current.year}-01-01"}).where(year_season_seasons:{id:season.id}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC'))
    @scores = Score.where(product_id:@pickup.ids).group("product_id").average_value

    @current_season2 = "#{current2.year} #{Kisetsu.find(@kisetsu2).name}"
    @pickup2 = Product.with_attached_bg_images.where(finished:1).left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls).year_season_scope.where(year_season_years:{year:"#{current2.year}-01-01"}).where(year_season_seasons:{id:season2.id}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC'))
    @scores2 = Score.where(product_id:@pickup2.ids).group("product_id").average_value

    # 
    # tier
    

    # tierGroup = TierGroup.find_by(year_id:year.id,kisetsu_id:season.id)
    # if tierGroup.present?
    #   @tier = tierGroup.tiers.includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    #   @tier_p = tierGroup.products.with_attached_bg_images.where(finished:1).includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc"))
    # else
     
    # end
    
    

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
    now = Time.current
    from = now.ago(3.month).beginning_of_month
    to = now.since(2.month).end_of_month
    # @delivery_end = Product.where(delivery_end:from...to).includes(:styles,:janls,:tags,:scores)
    # @delivery_start = Product.where(delivery_start:from...to).includes(:styles,:janls,:tags,:scores)
    @episord = Episord.where(release_date:from...to).includes(product: :styles).includes(product: {bg_images_attachment: :blob}).includes(product: :janls).includes(product: :scores).includes(product: {year_season_products: :year}).includes(product: {year_season_products: :kisetsu})
    @scores = Score.where(product_id:@episord.pluck(:product_id).uniq).group("product_id").average_value
    render :calendar,formats: :json
  end

  def worldclass
    now = Time.current 
    from = now.prev_year
    to = now.next_year

    case now.month
    when 1,2,3 then
      @kisetsu = 5
      @kisetsu_name = "冬"
    when 4,5,6 then
      @kisetsu = 2
      @kisetsu_name = "春"
    when 7,8,9 then
      @kisetsu = 3
      @kisetsu_name = "夏"
    when 10,11,12 then
      @kisetsu = 4
      @kisetsu_name = "秋"
  end
    # koko 
    style = Style.find_by(name:"Movie")
    season = Kisetsu.find_by(name:@kisetsu_name)
    # @worldclass = Product.with_attached_bg_images.where(finished:1).left_outer_joins(:styles).where(styles:{id:2}).where(delivery_start:from...to).includes(:styles,:janls).year_season_scope.order(delivery_start: :asc).limit(10)
    @worldclass = Product.left_outer_joins(:year_season_seasons,:year_season_years).with_attached_bg_images.where(finished:1).where(year_season_years:{year:"#{now.year}-01-01"}).where(year_season_seasons:{id:season.id}).left_outer_joins(:styles).where(styles:{id:style.id}).includes(:styles,:janls).year_season_scope.order(delivery_start: :asc).limit(10)
    @scores = Score.where(product_id:@worldclass.ids.uniq).group("product_id").average_value
    render :worldclass,formats: :json
  end

  def toptens
     # nouse toptencontrollerに移した。notest 2022 4/19
     now = Time.current 
     from = now.prev_month
     to = now
     @like_topten_month =  Product.with_attached_bg_images.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(10)
     @like_topten_all =  Product.with_attached_bg_images.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where.not(likes:{id:nil}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(10)
     @score_topten_month = Product.with_attached_bg_images.left_outer_joins(:scores).includes(:styles,:janls,:scores).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).order(id: :asc).limit(10)
     @score_topten_all = Product.with_attached_bg_images.left_outer_joins(:scores).includes(:styles,:janls,:scores).where.not(scores:{value:nil}).group("products.id").order(Arel.sql('avg(value) DESC')).order(id: :asc).limit(10)
     @acsess_topten_month = Product.with_attached_bg_images.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where(acsesses:{date:Time.current.prev_month.beginning_of_month...to}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10)
     @acsess_topten_all = Product.with_attached_bg_images.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where.not(acsesses:{id:nil}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(10)

     @review_topten_month = Product.with_attached_bg_images.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where(reviews:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)
     @review_topten_all = Product.with_attached_bg_images.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where.not(reviews:{id:nil}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(10)

     render :toptens,formats: :json
  end

  def populur_rt
    # doneyet_3 正確な月間ではない nouse notest
    to = Time.current 
    from = to.prev_month

    @popular_reviews = Review.left_outer_joins(:acsess_reviews).where(acsess_reviews:{updated_at:from..to}).includes(:user).includes(product: {bg_images_attachment: :blob}).group("reviews.id").order(Arel.sql("sum(count) desc")).limit(6)
    @popular_threads = Thered.left_outer_joins(:acsess_threads).where(acsess_threads:{updated_at:from..to}).includes(:user).includes(product: {bg_images_attachment: :blob}).group("thereds.id").order(Arel.sql("sum(count) desc")).limit(6)
    render :populur_rt,formats: :json
  end

  def ranking 
    current_time = Time.current 
    @from = current_time.prev_week(:monday).since(6.hours)   
    @to = @from.next_week.since(6.hours)
    @products = Product.left_outer_joins(:episords,:acsesses).includes(:episords,:weeklyrankings).where(episords:{release_date:@from..@to}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC')).limit(10)
    @weekly_count = Weeklyranking.where(product_id:@products.ids,weekly:@from.ago(6.hours)).group(:count).size.map{|x,v| x*v}.sum
    if session[:weekly_vote]
      if @to - session[:weekly_vote].since(6.hours) > 0
        # @weekly_vote = false
        # session[:weekly_vote] = nil
        @weekly_vote = true
      else
        session[:weekly_vote] = nil
        @weekly_vote = false
      end
    else
      @weekly_vote = false
    end
    render :ranking, formats: :json
  end

  def vote
    # check-1(設定 6時間)
    current_time = Time.current.ago(6.hours).prev_week(:monday)
    begin
      @week = Week.where(week:current_time).first_or_initialize
      if @week.save
      else
        render json:{status:500,message:{title:"予期しないエラーが発生しました。もう一度試すか、お問い合わせください。",select:0}}
        return
      end
      params[:episord_ids].each do |e|
      weekEpisord = WeekEpisord.where(week_id:@week.id,episord_id:e).first_or_initialize
        if weekEpisord.save
        else
          render json:{status:500,message:{title:"予期しないエラーが発生しました。もう一度試すか、お問い合わせください。",select:0}}
          return
        end
      end
      @vote = Weeklyranking.where(product_id:params[:product_id],weekly:current_time,week_id: @week.id).first_or_initialize
      @vote.count = @vote.count.nil?? 1 : @vote.count + 1   
      if @vote.save
        session[:weekly_vote] = @vote.weekly
        @weekly_vote = true
        @from = current_time.since(6.hours)   
        @to = @from.next_week.since(6.hours)
        @products = Product.left_outer_joins(:episords,:acsesses).includes(:episords,:weeklyrankings).where(episords:{release_date:@from..@to}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC')).limit(10)
        @weekly_count = Weeklyranking.where(product_id:@products.ids,weekly:@from.ago(6.hours)).group(:count).size.map{|x,v| x*v}.sum
        render :vote, formats: :json
      else
        render json:{status:500,message:{title:"予期しないエラーが発生しました。もう一度試すか、お問い合わせください。",select:0}}
      end
      
    rescue =>e
      @EM = ErrorManage.new(controller:"mainblocks/mains/vote",error:"#{e}".slice(0,200))
      @EM.save
      render json:{status:500,message:{title:"予期しないエラーが発生しました。もう一度試すか、お問い合わせください。",select:0}}
    end
  end

  def create_tier
    # check
    begin
      year = params[:season][0..3]
      kisetsu = params[:season].last
      @year = Year.find_by(year:"#{year}-01-01")
      @kisetsu = Kisetsu.find_by(name:kisetsu)
      @tier_group = TierGroup.where(year_id:@year.id,kisetsu_id:@kisetsu.id).first_or_initialize
      @tier_group.save!
      @user_tier_group = UserTierGroup.where(user_id:params[:user_id],tier_group:@tier_group.id).first_or_initialize
      @user_tier_group.save!

      tier_array = []
      params[:group_product].each do |e|
        e[:product].each do |product|
          @tier = Tier.where(product_id:product,user_id:params[:user_id],tier_group_id: @tier_group.id,user_tier_group_id:@user_tier_group.id).first_or_initialize
          case e[:group]
          when 0 then
            @tier.tier = 100
          when 1 then
            @tier.tier = 80
          when 2 then
            @tier.tier = 60
          when 3 then
            @tier.tier = 40
          when 4 then
            @tier.tier = 20
          when 5 then
            @tier.tier = 0
          else
          end
          if @tier.save
            tier_array << @tier
          else
            render json:{status:500}
            return
          end
        end
      end

      @user_tier_group.tiers = tier_array
      @user_tier_group.save!
      render json:{status:200,message:{title:"#{year}年 #{kisetsu}シーズンのTierを更新しました。",select:1}}
    rescue => e
      @EM = ErrorManage.new(controller:"mainblocks/mains/create_tier",error:"#{e}".slice(0,200))
      @EM.save
      render json:{status:500}
    end


  end

  def user_this_season_tier
    if params[:current_number] == "1"
      @time = Time.current
    elsif params[:current_number] == "2"
      @time = Time.current.ago(3.month)
    end

    case @time.month
    when 1,2,3 then
      # @kisetsu = 5
      @kisetsu_name = "冬"
    when 4,5,6 then
      # @kisetsu = 2
      @kisetsu_name = "春"
    when 7,8,9 then
      # @kisetsu = 3
      @kisetsu_name = "夏"
    when 10,11,12 then
      # @kisetsu = 4
      @kisetsu_name = "秋"
    end
    
    @year = Year.find_by(year:"#{@time.year}-01-01")
    @kisetsu = Kisetsu.find_by(name:@kisetsu_name)
    group = TierGroup.find_by(year_id:@year.id,kisetsu_id:@kisetsu.id)
    if group.present?
      @tier_group =  group.tiers.includes(product: {bg_images_attachment: :blob}).where(user_id:params[:user_id])
    else

    end
    @current_season = "#{@time.year} #{@kisetsu.name}"
    render :user_this_season_tier, formats: :json
  end

  def user_this_season_tier_user_page
    if params[:current_number] == "1"
      @time = Time.current
    elsif params[:current_number] == "2"
      @time = Time.current.ago(3.month)
    end

    case @time.month
    when 1,2,3 then
      # @kisetsu = 5
      @kisetsu_name = "冬"
    when 4,5,6 then
      # @kisetsu = 2
      @kisetsu_name = "春"
    when 7,8,9 then
      # @kisetsu = 3
      @kisetsu_name = "夏"
    when 10,11,12 then
      # @kisetsu = 4
      @kisetsu_name = "秋"
    end
    
    @year = Year.find_by(year:"#{@time.year}-01-01")
    @kisetsu = Kisetsu.find_by(name:@kisetsu_name)
    group = TierGroup.find_by(year_id:@year.id,kisetsu_id:@kisetsu.id)
    if group.present?
      @tier_group =  group.tiers.includes(product: {bg_images_attachment: :blob}).where(user_id:params[:user_id])
    else

    end
    @current_season = "#{@time.year} #{@kisetsu.name}"
    @new_netflix = Product.with_attached_bg_images.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:"#{@time.year}-01-01"}).where(year_season_seasons:{id:@kisetsu}).group("products.id").order(Arel.sql('sum(count) DESC'))
    render :user_this_season_tier_user_page, formats: :json
  end


  def get_user_tier_2
    
    @year = Year.find(params[:year])
    @kisetsu = Kisetsu.find(params[:kisetsu])
    group = TierGroup.find_by(year_id:@year.id,kisetsu_id:@kisetsu.id)
    if group.present?
      @tier_group =  group.tiers.includes(:product).where(user_id:params[:user_id])
    else

    end
    @current_season = "#{@year.year} #{@kisetsu.name}"
    @new_netflix = Product.with_attached_bg_images.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:@year.year}).where(year_season_seasons:{id:@kisetsu.id}).group("products.id").order(Arel.sql('sum(count) DESC'))
    render :get_user_tier_2 , formats: :json
  end


  def update_tier_list
    if params[:current_number] == "1"
      @time = Time.current
    elsif params[:current_number] == "2"
      @time = Time.current.ago(3.month)
    end
    case @time.month
    when 1,2,3 then
      @kisetsu_name = "冬"
    when 4,5,6 then
      @kisetsu_name = "春"
    when 7,8,9 then
      @kisetsu_name = "夏"
    when 10,11,12 then
      @kisetsu_name = "秋"
    end
    @year = Year.find_by(year:"#{@time.year}-01-01")
    if @year.present?
    else
      # Year.create(year:"#{@time.year}-01-01")
      year = Year.where(year:"#{@time.year}-01-01").first_or_initialize
      year.save
    end
    @kisetsu = Kisetsu.find_by(name:@kisetsu_name)
    tierGroup = TierGroup.find_by(year_id:@year.id,kisetsu_id:@kisetsu.id)
    if tierGroup.present?
      @tier = tierGroup.tiers.includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
      @tier_p = tierGroup.products.with_attached_bg_images.where(finished:1).includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc"))
      render :update_tier_list,formats: :json
    else
      render json:{tier:[],tierAverage:[]}
    end

  end

end