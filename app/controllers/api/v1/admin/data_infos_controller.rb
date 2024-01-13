class Api::V1::Admin::DataInfosController < ApplicationController

  def index
    info = DataInfo.first
    # render json:{status:200,info:info.info}
    if info
      render json: { status: 200, info: info.info }
    else
      render json: { status: 200, info: "DataInfo not found" }
    end
  end
  def update
    begin
      info = DataInfo.where(id:params[:info_id]).first_or_initialize
      info.info = params[:info]
      info.save!
      render json:{status:200}
    rescue=>e
      render json:{status:500}
    end
  end
end
