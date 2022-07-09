json.set! :product do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.image_url
  json.arasuzi @product.description
  json.list @product.list
  json.image_url2 @product.image_url2
  json.image_url3 @product.titleKa
  json.image_urlh1 @product.titleEn
  json.image_urlh2 @product.titleRo
  json.image_urlh3 @product.wiki
  json.wikiEn @product.wikiEn
  json.copyright @product.copyright
  json.arasuzi_copyright @product.arasuzi_copyright
  json.annitictId @product.annitict
  json.shoboiTid @product.shoboiTid

  json.year @product.year
  json.delivery_start @product.delivery_start
  json.delivery_end @product.delivery_end
  json.overview @product.overview
  
  json.form_style do
    json.array! @product.styles do |a|
      json.value = a.id
      json.label = a.name
    end
  end
  json.form_genre do
    json.array! @product.janls do |a|
      json.value = a.id
      json.label = a.name
    end
  end

  json.form_cast do
    json.array! @product.casts do |a|
      json.value = a.id
      json.label = a.name
    end
  end
  json.form_character do
    json.array! @product.characters do |a|
      json.id a.id
      json.castId a.cast_id
      json.characterName a.name
      json.characterImage a.image
    end
  end

  json.form_studio do
    json.array! @product.studios do |a|
      json.value = a.id
      json.label = a.company
    end
  end
  json.form_staff do
    json.array! @product.staffs do |a|
      json.value = a.id
      json.label = a.name
    end
  end

  json.form_occupation do
    json.array! @product.occupations do |a|
      json.castId = a.staff_id
      json.characterName = a.name
    end
  end

  json.form_episord do
    json.array! @product.episords do |a|
      json.episordNumber = a.episord
      json.episordTittle = a.title
      json.episordArasuzi = a.arasuzi
      json.episordImageUrl = a.image
      json.episordTime = a.time
      json.episordReleaseDate = a.release_date
    end
  end
  # json.form_year_season do 
  #   json.array! @yearSeason do |ys|
  #     json.year = ys.year.year
  #     json.season = ys.kisetsu.id
  #   end
  # end

  json.form_year_season do
    json.array!  @year do |ys|
      json.year = ys.year.year
      json.season = ys.year_season_seasons.where(year_season_products:{product_id:@product.id}).ids
    end
  end



  json.product_genres do
    json.array! @product.janls
  end
  json.episords do
    json.array! @product.episords
  end
  json.product_character do
    json.array! @product.characters
  end
  json.product_staff do
    json.array! @product.occupations
  end
  json.product_kisetsu do
    json.array! @product.kisetsus
  end
  json.product_year do
    json.array! @product.years
  end

end