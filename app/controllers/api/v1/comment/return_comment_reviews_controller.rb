class Api::V1::Comment::ReturnCommentReviewsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy,:returnreturn]

  def index
    # params[:comment_review_id]
    # userは対１関係なため、includesに含めない。
    @returncomment = ReturnCommentReview.includes(:like_return_comment_reviews,:user,return_returns: :user).include_tp_img.where(comment_review_id:params[:comment_review_id]).page(params[:page]).per(3)
    render :index,formats: :json
  end

  def create
    begin
      # puts params[:return_comment_review][:comment_review_id]
      @review = CommentReview.find(params[:return_comment_review][:comment_review_id])
      # @review = Review.find(params[:review_id])
      @review_length = @review.return_comment_reviews.length
      if @review_length>=Concerns::LIMIT_COMMENT[:return_comment]
        render json:{status:494}
        return
      end
      if @review.return_comment_reviews.includes(:user).where(user_id:current_user.id).length >= Concerns::LIMIT_COMMENT[:user_comment]
        render json:{status:495}
        return
      end

      if @review_length>=Concerns::LIMIT_COMMENT[:fortsetzen]
        last3 = @review.return_comment_reviews.last(Concerns::LIMIT_COMMENT[:last])
        last3_count = last3.map{|k| k.user_id }.uniq.count
        if last3_count ==1
          if last3[0].user_id == current_user.id
            render json:{status:490}
            return
          end
        end
      end

      @commentReview = ReturnCommentReview.new(create_params)
      @commentReview.save!
      render json: {status:200,commentReview:@commentReview}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:return_comment_review][:comment_review_id])
          @EM = ErrorManage.new(controller:"return_comment_review/create",error:"#{e}".slice(0,200))
          @EM.save
          render json: {status:500}
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end      
    end
  end
  
  def returnreturn
    begin
      @review = CommentReview.find(params[:return_comment_review][:comment_review_id])
      # @review = Review.find(params[:review_id])
      @review_length = @review.return_comment_reviews.length
      if @review_length>=Concerns::LIMIT_COMMENT[:return_comment]
        render json:{status:494}
        return
      end
      if @review.return_comment_reviews.includes(:user).where(user_id:current_user.id).length >= Concerns::LIMIT_COMMENT[:user_comment]
        render json:{status:495}
        return
      end

      if @review_length>=Concerns::LIMIT_COMMENT[:return_fortsetzen]
        last3 = @review.return_comment_reviews.last(Concerns::LIMIT_COMMENT[:return_last])
        last3_count = last3.map{|k| k.user_id }.uniq.count
        if last3_count ==1
          if last3[0].user_id == current_user.id
            render json:{status:490}
            return
          end
        end
      end

      @commentReview = ReturnCommentReview.new(create_params2)
      @commentReview.return_return_comment_reviews.build(return_create_params)
      @commentReview.save!
      render :returnreturn, formats: :json
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:return_comment_review][:comment_review_id])
          if ReturnCommentReview.exists?(id:params[:return_return_comment_review][:return_return_id])
            @EM = ErrorManage.new(controller:"return_comment_review/return_return",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:430}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end   
    end
  end

  def destroy
    begin
      @review_comment = ReturnCommentReview.find(params[:id])
      @review_comment.destroy
      render json: {status:200}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:comment_review_id])
          if ReturnCommentReview.exists?(id:params[:id])
            @EM = ErrorManage.new(controller:"return_comment_review/destroy",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:420}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end
    end
  end

  private
  def create_params
    params.require(:return_comment_review).permit(:user_id,:comment_review_id,:comment)
  end
  def create_params2
    params.require(:return_comment_review).permit(:user_id,:comment_review_id,:comment).merge(reply:true)
  end

  def return_create_params
    params.require(:return_return_comment_review).permit(:return_comment_review_id,:return_return_id)
  end
  
end
