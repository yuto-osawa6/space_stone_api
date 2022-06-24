class OgpCreator
  require 'mini_magick'  
  BASE_IMAGE_PATH = './public/MeruPlanetOgp2.png'
  # 3か1
  SHADOW_IMAGE_PATH2 = './public/background/MeruPlanetBack_half_trans3.png'
  SHADOW_IMAGE_PATH3 = "./public/waku/merupla-waku.png"
  GRAVITY = 'northwest'
  TEXT_POSITION = '50,95'
  FONT = './public/Noto_Sans_JP/NotoSansJP-Medium.otf'
  FONT_SIZE = 60
  INDENTION_COUNT = 18
  ROW_LIMIT = 2
  TEXT_POSITION2 = '50,270'
  # 50 95 183 270 359

  def self.build(image_url,product,average)
    text = prepare_text("#{product.title}")
    # image_url1 = image_url.blank?? BASE_IMAGE_PATH : image_url
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|        
      config.blur "50,50"
    end
    # result1 = image.composite(MiniMagick::Image.open(SHADOW_IMAGE_PATH2)) do |config|
    #   config.compose 'Over'
    #   config.gravity 'NorthWest'
    # end
    # result = result1.composite(MiniMagick::Image.open(SHADOW_IMAGE_PATH3)) do |config|
    #   config.compose 'Over'
    #   config.gravity 'NorthWest'
    #   config.geometry '+500+260'
    # end
    # result.combine_options do |config|        
    #   config.font FONT
    #   config.fill '#f0f8ff'
    #   config.gravity GRAVITY
    #   config.pointsize FONT_SIZE
    #   config.draw "text #{TEXT_POSITION} '#{text}'"
    # end
    # if average != 0
    #   result.combine_options do |config|        
    #     config.font FONT
    #     config.fill '#f0f8ff'
    #     config.gravity GRAVITY
    #     config.pointsize 50
    #     config.draw "text #{TEXT_POSITION2} '★ #{average}/100'"
    #   end
    # end

    # if product.episords.length != 0
    #   result .combine_options do |config|        
    #     config.font FONT
    #     config.fill 'grey'
    #     config.gravity GRAVITY
    #     config.pointsize 30
    #     config.draw "text 50,50 'エピソード #{product.episords.last.episord}'"
    #   end
    # end
    # # product.studios.map

    # result.combine_options do |config|        
    #   config.font FONT
    #   config.fill '#38B6FF'
    #   config.gravity GRAVITY
    #   config.pointsize 30
    #   config.draw "text 50,370 '#{product.studios.map { |user| user.company }.join(',')}'"
    #   # users.map { |user| user.name }
    # end

    # result .combine_options do |config|        
    #   config.font FONT
    #   config.fill '#ffffff'
    #   config.gravity GRAVITY
    #   config.pointsize FONT_SIZE
    #   config.draw "text #{TEXT_POSITION} '#{text}'"
    #   config.background 'blue'
    # end

    # image.combine_options do |config|        
    #   config.font FONT
    #   config.fill 'black'
    #   config.gravity GRAVITY
    #   config.pointsize FONT_SIZE
    #   config.draw "text #{TEXT_POSITION2} '☆20'"
    #   config.background 'blue'
    # end

    # image.combine_options do |config|        
    #   config.font FONT
    #   config.fill 'black'
    #   config.gravity GRAVITY
    #   config.pointsize FONT_SIZE
    #   config.draw "text #{TEXT_POSITION} 'Scoreは20'"
    #   config.background 'blue'
    # end

  end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end