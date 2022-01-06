class Api::V1::ProductsController < ApplicationController
  # before_action :authenticate_api_v1_user!, only: :red
  def left
    @styles = Style.all.includes(:products)
    @genres = Janl.all.includes(:products)

    render :left,formats: :json

  end


 

  def index
    @products = Product.all.where(finished:0).limit(30)

    # @q = Product.ransack(params[:q])
    # @products = @q.result.where(finished:0).limit(30)
  
    # render :index,formats: :json
    @pss = {
      "10"=> 0,
      "20"=> 0,
      "30"=> 0,
      "40"=> 0,
      "50"=> 0,
      "60"=> 0,
      "70"=> 0,
      "80"=> 0,
      "90"=> 0,
      "100"=> 0,
    } 
    # @aaa = [1,2,3,5,0,-1]
    @aaa = {
      "10"=> 1,
      "20"=> 2,
      "30"=> 60,
      "40"=> 2,
      "50"=> 10,
      "60"=> 4,
      "70"=> 2,
      "80"=> 1,
      "90"=> 0,
      "100"=> 1,
      # "baba"
    }
    # aaaa = []
    # @aaa["10"]=100
    # @aaa["20"]=100

    # # @aaa.map{|item|aaaa.push(@aaa[item])}
    # @aaa.map{|key,item|aaaa.push(@aaa[key])}

    # # @qp= @pp.map(|key,value|pss[key],value)
    # @pp = Product.find(11).scores.group(:value).count
    # @pp.map{|key,value|@pss["#{key}"]=value
    #   # @pss.map{|key,value|array.append(@pss[key])}
    # }
    # array = []
    # @pss.length
    # @pss.map{|key,value|array.push(@pss[key])}
    # # @qp= @pp.map{|key,value|[key,value]}
    # render json: {product: @pp,qp:@qp,pss:@pss,ar:array,aaa:@aaa,aaaa:aaaa}
    

    to = Time.current.at_beginning_of_day
    d = Date.today
    dm = d.month
    month_array = []
    month_hash = {}
      (1..12).each do |i|
        i=dm+i
        if i > 12
          i = i-12
        end
        month_array.push(i)
        month_hash[i] = 0
      end
    # to = Time.current.all_month

    from  = (to - 1.year).next_month.beginning_of_month
    @acsesses = Product.find(11).acsesses.where(date: from...to).group(:date).sum(:count)
    # @acsesses.map{|key,value|month_hash[key.month]=value}

    # @acsesses_array = []
    # month_hash.map{|key,value|@acsesses_array.push(month_hash[key])}
    # @acsesses.map{|key,value|@pss2["#{key}"]=value}

    # 
    oei= Product.find(11).scores.average(:value)

    render json: {
      # product: @acsesses,
      dm:dm,
      month_array:month_array,
      month_hash:month_hash,
      from:from,
      to:to,
      acsess:@acsesses,

      a:oei

      # kk:@acsesses_array
    }

    

  end

  def search()
    puts @grid
  end

  def red
    content = params[:content]
    review  = Review.create({title:params[:text],discribe:params[:discribe],content:content,user_id:3,product_id:11})
    render json: {review:review}

  end

  def show
    @pss = {
      "10"=> 0,
      "20"=> 0,
      "30"=> 0,
      "40"=> 0,
      "50"=> 0,
      "60"=> 0,
      "70"=> 0,
      "80"=> 0,
      "90"=> 0,
      "100"=> 0,
    } 

    # puts current_user.id
    if current_user
      @liked = current_user.already_liked?(params[:id])
      @scored = current_user.scores.exists?(product_id: params[:id])
      if @liked
        @like = Like.find_by(product_id: params[:id], user_id: current_user.id)
      end
      if @scored
        @score = Score.find_by(product_id: params[:id], user_id: current_user.id)
      end
    else
      @liked = false
      @scored = false
    end
    @product = Product.find(params[:id])
    # .includes(:genres,:styles)
    @stats = @product.scores.group(:value).count
    @stats.map{|key,value|@pss["#{key}"]=value}
    @stats_array = []
    @pss.map{|key,value|@stats_array.push(@pss[key])}

    # acsesses_array
    to = Time.current.at_beginning_of_day
    to2 = Time.current.end_of_day
    d = Date.today
    dm = d.month
    @month_array = []
    @month_hash = {}
      (1..12).each do |i|
        i=dm+i
        if i > 12
          i = i-12
        end
        @month_array.push(i)
        @month_hash[i] = 0
      end

    from  = (to - 1.year).next_month.beginning_of_month
    @acsesses = Product.find(params[:id]).acsesses.where(date: from...to2).group(:date).sum(:count)
    @acsesses.map{|key,value|@month_hash[key.month]=value}

    @acsesses_array = []
    @month_hash.map{|key,value|@acsesses_array.push(@month_hash[key])}

    # 追加
    if @product.scores.exists?
      # puts @product.scores.exists?
      # puts "aaaaaaaa"
      @average_score = @product.scores.average(:value).round(1)
    end
    @like_count = @product.likes.count

    # 追加 reviews
    # @reviews = @product.reviews.limit(1)

    # 追加
    # @quesionids = @product.thereds.thered_question_questions
    @quesion = Question.all


    render :show,formats: :json
  end 

  private
    def user_params
      params.require(:review).permit(:content).merge(product_id:11,user_id:3,title:"aaa")
    end

end
