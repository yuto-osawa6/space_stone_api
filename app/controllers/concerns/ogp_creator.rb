class OgpCreator
  require 'mini_magick'  
  BASE_IMAGE_PATH = './public/MeruPlanetG/merupla-ogp3.png'
  GRAVITY = 'northwest'
  TEXT_POSITION = '50,55'
  FONT = './public/font/MPLUSRounded1c-Medium.ttf'
  FONT_SIZE = 60
  INDENTION_COUNT = 18
  ROW_LIMIT = 3
  TEXT_POSITION2 = '50,460'
  # 50 95 183 270 359

  def self.build(image_url,product,average)
    text = prepare_text("#{product.title}")
    # image_url1 = image_url.blank?? BASE_IMAGE_PATH : image_url
    result = MiniMagick::Image.open(BASE_IMAGE_PATH)
    # image.combine_options do |config|        
    #   # config.blur 50
    # end
    # result1 = image.composite(MiniMagick::Image.open(SHADOW_IMAGE_PATH2)) do |config|
    #   config.compose 'Over'
    #   # config.gravity 'NorthWest'
    # end
    # result = result1.composite(MiniMagick::Image.open(SHADOW_IMAGE_PATH3)) do |config|
    #   config.compose 'Over'
    #   # config.gravity 'NorthWest'
    #   config.geometry '+500+260'
    # end
    result.combine_options do |config|        
      config.font FONT
      config.fill '#f0f8ff'
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.draw "text #{TEXT_POSITION} '#{text}'"
      if average != 0
        config.draw "text #{TEXT_POSITION2} '★ #{average}/100'"
      end
      config.pointsize 30
      config.draw "text 50,560 '#{product.studios.map { |user| user.company }.join(',')}'"
    end
  end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end