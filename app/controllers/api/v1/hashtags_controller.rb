class Api::V1::HashtagsController < ApplicationController
  # notest
  def create 
    begin 
      hash_name = params[:hash]
      hash = Hashtag.where(name:hash_name).first_or_initialize
      if hash.new_record?
        hash.save!
        render json:{status:200}
        return
      end
      render json:{status:300}
    rescue =>e
      render json:{status:500}
    end
  end
end
