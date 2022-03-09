class Api::V1::Mainblocks::MainsController < ApplicationController
  def new_netflix
    # @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).includes(:styles,:janls,:tags,:scores).order(delivery_start:"desc")
    # v2.0
    # @new_netflix = Product.
    current = Time.current
    puts current.month

    case current.month
      when 1,2,3 then
        @kisetsu = 5
      when 4,5,6 then
        @kisetsu = 2
      when 7,8,9 then
        @kisetsu = 3
      when 10,11,12 then
        @kisetsu = 4
    end

    @current_season = "#{current.year} #{Kisetsu.find(@kisetsu).name}"
    @new_netflix = Product.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:"#{current.year}-01-01"}).where(year_season_seasons:{id:@kisetsu}).group("products.id").order(Arel.sql('sum(count) DESC'))
    # Product.joins(:kisetsus).where(year:current.year).where(kisetsus:{id:@kisetsu}).order(Arel.sql('sum(count) DESC'))
    render :new_netflix,formats: :json
  end

  def pickup
    # @pickup = Product.where(pickup:true).includes(:styles,:janls,:tags,:scores)
    current = Time.current.ago(3.month)
    current2 = Time.current.since(3.month)
    puts current.month

    case current.month
      when 1,2,3 then
        @kisetsu = 5
      when 4,5,6 then
        @kisetsu = 2
      when 7,8,9 then
        @kisetsu = 3
      when 10,11,12 then
        @kisetsu = 4
    end

    case current2.month
    when 1,2,3 then
      @kisetsu2 = 5
    when 4,5,6 then
      @kisetsu2 = 2
    when 7,8,9 then
      @kisetsu2 = 3
    when 10,11,12 then
      @kisetsu2 = 4
  end

    @current_season = "#{current.year} #{Kisetsu.find(@kisetsu).name}"
    @pickup = Product.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:"#{current.year}-01-01"}).where(year_season_seasons:{id:@kisetsu}).group("products.id").order(Arel.sql('sum(count) DESC'))

    @current_season2 = "#{current2.year} #{Kisetsu.find(@kisetsu2).name}"
    @pickup2 = Product.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:"#{current2.year}-01-01"}).where(year_season_seasons:{id:@kisetsu2}).group("products.id").order(Arel.sql('sum(count) DESC'))

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
    @delivery_start = Product.where(delivery_start:from...to).includes(:styles,:janls,:tags,:scores)
    @episord = Episord.where(release_date:from...to).includes(product: :styles).includes(product: :janls).includes(product: :scores)
    render :calendar,formats: :json
  end

  def worldclass
    # @period = Period.order(created_at:"desc").limit(1)
    # @topten = @period[0].toptens.where.not(product_id:nil).includes(product: :styles).includes(product: :janls).includes(product: :scores)
    now = Time.current 
    from = now.prev_year
    to = now.next_year
    @worldclass = Product.left_outer_joins(:styles).where(styles:{id:2}).where(delivery_start:from...to).includes(:styles,:janls,:scores)
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

  def ranking 
    current_time = Time.current 
    @from = current_time.prev_week(:monday).since(6.hours)   
    @to = @from.next_week.since(6.hours)
    @products = Product.left_outer_joins(:episords,:acsesses).includes(:episords,:weeklyrankings).where(episords:{release_date:@from..@to}).group("products.id").order(Arel.sql('sum(acsesses.count) DESC')).limit(10)
    @weekly_count = Weeklyranking.where(product_id:@products.ids,weekly:@from.ago(6.hours)).group(:count).size.map{|x,v| x*v}.sum
    if session[:weekly_vote]
      if @to - session[:weekly_vote].since(6.hours) > 0
        @weekly_vote = false
        session[:weekly_vote] = nil
        # @weekly_vote = true
      else
        session[:weekly_vote] = nil
        @weekly_vote = false
      end
    else
      @weekly_vote = false
    end

    # render json:{products:@products,from:from,to:to,weekly_vote:@weekly_vote }
    render :ranking, formats: :json
  end

  def vote
    puts session[:ranking]
    # doneyet-1(設定 6時間)
    current_time = Time.current.ago(6.hours).prev_week(:monday)
    @week = Week.where(week:current_time).first_or_initialize
    @week.episord_ids = params[:episord_ids]
    @week.save

    @vote = Weeklyranking.where(product_id:params[:product_id],weekly:current_time,week_id: @week.id).first_or_initialize
    puts @vote.inspect
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
      render json:{ }
    end
   
  end

  def create_tier
    year = params[:season][0..3]
    kisetsu = params[:season].last
    
    @year = Year.find_by(year:"#{year}-01-01")
    @kisetsu = Kisetsu.find_by(name:kisetsu)

    @tier_group = TierGroup.where(year_id:@year.id,kisetsu_id:@kisetsu.id).first_or_initialize
    @tier_group.save

    params[:group_product].each do |e|
      e[:product].each do |product|
        @tier_group = Tier.where(product_id:product,user_id:params[:user_id],tier_group_id: @tier_group.id).first_or_initialize
        case e[:group]
        when 0 then
          @tier_group.tier = 100
        when 1 then
          @tier_group.tier = 80
        when 2 then
          @tier_group.tier = 60
        when 3 then
          @tier_group.tier = 40
        when 4 then
          @tier_group.tier = 20
        when 5 then
          @tier_group.tier = 0
        else
        end
        @tier_group.save
      end
    end


  end

end