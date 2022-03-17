require "graphql/client"
require "graphql/client/http"

module SWAPI
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new("https://api.annict.com/graphql") do
    def headers(context)
      {"Authorization":ENV['ANNICT']}
    end
  end  
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

end

class Annict
    # AnnictQuery = SWAPI::Client.parse <<~'GRAPHQL'
    #   query($seasons:[String!]){
    #   searchWorks(
    #     seasons: $seasons,
    #     orderBy: { field: WATCHERS_COUNT, direction: DESC },
    #     # first: 2
    #   ) {
    #     edges {
    #       node {
    #         # annictId
    #         title
    #         # seasonName 
    #         # seasonYear
    #       }
    #     }
    #   }
    # } 
    # GRAPHQL
    AnnictQuery = SWAPI::Client.parse <<~'GRAPHQL'
    query($seasons:[String!]) {
      searchWorks(
        seasons: $seasons
        orderBy: { field:  WATCHERS_COUNT, direction: DESC },
        first: 10
      ) {
        edges {
          node {
            annictId
            title
            titleKana
            titleEn
            titleRo
            id
            media
            officialSiteUrl
            officialSiteUrlEn
            seasonName 
            seasonYear
            wikipediaUrl
            wikipediaUrlEn
            syobocalTid
            image{
              id
              copyright 
              facebookOgImageUrl
              recommendedImageUrl
            }
            episodes(
              orderBy: { field: SORT_NUMBER, direction: ASC },
              # first: 2
            ) {
              edges {
                node {
                  number
                  title
                }
              }
            }
            
            casts(
              orderBy: { field: SORT_NUMBER, direction: ASC },
              # first: 2
            ) {
              edges {
                node {
                  id
                  name
                  person{
                    nameEn
                    nameKana
                  }
                  character{
                    name
                    nameKana
                  }
                  
                }
              }
            }
             staffs(
              orderBy: { field: SORT_NUMBER, direction: ASC },
              # first: 2
            ) {
              edges {
                node {
                  name
                  roleText
                  sortNumber 
                  
                }
              }
            }
          }
        }
      }
    }
    GRAPHQL
   
  def select_season
    season = gets.chomp
    @result = result(seasons:["#{season}"])
    # return heroQuery
  end

  def season
    time = Time.current
    repetition_length = time.year % 100

    year = []
    year << time.year
    for num in 1..repetition_length do
      number = repetition_length-num
      number_sprintf= format("%02d", number) 
      year<<"20#{number_sprintf}"
    end
   
    # puts year

    season = ["winter","spring","summer","autumn"]
    return season,year
  end

  def setup
    season,year = season()
    puts season,year

    use_season = "#{year[1]}-#{season[0]}"
    puts use_season

    @result = result(seasons:["#{use_season}"])

    # puts @result.to_h
    puts @result.original_hash["data"]["searchWorks"]["edges"].length

    @result.original_hash["data"]["searchWorks"]["edges"].each do |a|
      work = a["node"]
      puts a
      # @product = 
      @product = Product.where(title:work["title"]).first_or_initialize
      @product.annitict = work["annictId"]
      @product.titleKa = work["titleKana"]
      @product.titleEn = work["titleEn"]
      @product.titleRo = work["titleRo"]
      @product.list = work["officialSiteUrl"]
      @product.wiki = work["wikipediaUrl"]
      @product.wikiEn = work["wikipediaUrlEn"]
      @product.shoboiTid = work["syobocalTid"]
      @product.image_url = work["image"]["recommendedImageUrl"]
      @product.image_url2 = work["image"]["facebookOgImageUrl"]
      @product.copyright = work["image"]["copyright"]
      @product.save

      # style 
      if work["media"] == "TV"
        media = "TV show"
      elsif work["media"] == "MOVIE"
        media = "Movie"
      else
        media = work["media"]
      end
      @style = Style.where(name:media).first_or_initialize
      @product.style_ids = @style.id

      # season
      case work["seasonName"]
      when "WINTER" then
        @kisetsu = Kisetsu.find(5)
      when "SPRING" then
        @kisetsu = Kisetsu.find(2)
      when "AUTUMN" then
        @kisetsu = Kisetsu.find(3)
      when "SUMMER" then
        @kisetsu = Kisetsu.find(4)
      else
        @kisetsu = Kisetsu.where(name:work["seasonName"]).first_or_initialize
        @kisetsu.save
      end

      @product.kisetsu_ids = @kisetsu.id

      # year
      @year = Year.where(year:"#{work["seasonYear"]}-01-01").first_or_initialize
      @product.year_ids = @year.id

      # casts
      character = []
      work["casts"]["edges"].each do |cast|
        c = cast["node"]
        @cast = Cast.where(name:c["name"]).first_or_initialize
        @cast.save
        @character = Character.where(cast_id:@cast.id,product_id:@product.id,name:c["character"]["name"]).first_or_initialize
        puts @character.inspect
        character << @character
        @character.save
      end
      @product.characters = character

      # staffs
      staffs = []
      work["staffs"]["edges"].each do |staff|
        s = staff["node"]
        if s["roleText"] == "その他" 
          next
        end
        if s["roleText"] == "アニメーション制作" 
          next
        end
        @staff = Staff.where(name:s["name"]).first_or_initialize
        @staff.save
        @occupations = Occupation.where(staff_id:@staff.id,product_id:@product.id).first_or_initialize
        @occupations.name = s["roleText"] 
        staffs << @occupations
        @occupations.save
      end
      @product.occupations = staffs

      # episords
      episords = []
      work["episodes"]["edges"].each do |episord|
        e = episord["node"]
        @episord = Episord.where(episord:e["number"],product_id:@product.id).first_or_initialize
        @episord.title = e["title"]
        # @episord.arasuzi = i[:episord_arasuzi]
        # @episord.image = i[:episord_image_url]
        # @episord.time = i[:episord_time]
        # @episord.release_date =i[:episord_release_date]
        @episord.save
        episords << @episord
      end
      @product.episords = episords

      # yearSeason
      yearSeason = []  
      @yearSeason = YearSeasonProduct.where(product_id:@product.id,kisetsu_id:@kisetsu.id,year_id:@year.id).first_or_initialize
      puts @yearSeason.inspect
      yearSeason << @yearSeason
      puts yearSeason
      @product.year_season_products = yearSeason

      @product.save
    end
  end


  private
  def result(variables = [])
    puts variables
    response = SWAPI::Client.query(AnnictQuery, variables: variables)
  end

end



# [{"node"=>
#   {"annictId"=>8365,
#    "title"=>"その着せ替え人形は恋をする",
#    "titleKana"=>"そのびすくどーるはこいをする",
#    "titleEn"=>"Sono Bisque Doll wa Koi wo Suru",
#    "titleRo"=>"",
#    "id"=>"V29yay04MzY1",
#    "media"=>"TV",
#    "officialSiteUrl"=>"https://bisquedoll-anime.com/",
#    "officialSiteUrlEn"=>"",
#    "seasonName"=>"WINTER",
#    "seasonYear"=>2022,
#    "wikipediaUrl"=>"https://ja.wikipedia.org/wiki/その着せ替え人形は恋をする",
#    "wikipediaUrlEn"=>"https://en.wikipedia.org/wiki/My_Dress-Up_Darling",
#    "syobocalTid"=>6200,
#    "image"=>
#     {"id"=>"V29ya0ltYWdlLTU0NDc=",
#      "copyright"=>"福田晋一/SQUARE ENIX・「着せ恋」製作委員会",
#      "facebookOgImageUrl"=>"https://bisquedoll-anime.com/ogp.png?new",
#      "recommendedImageUrl"=>"https://bisquedoll-anime.com/ogp.png?new"},
#    "episodes"=>{"edges"=>[{"node"=>{"number"=>1, "title"=>"自分とは真逆の世界で生きている人"}}, {"node"=>{"number"=>2, "title"=>"さっそく、しよっか？"}}]},
#    "casts"=>
#     {"edges"=>
#       [{"node"=>{"id"=>"Q2FzdC01NDcyNA==", "name"=>"直田姫奈", "person"=>{"nameEn"=>"", "nameKana"=>"すぐたひな"}, "character"=>{"name"=>"喜多川海夢", "nameKana"=>"きたがわまりん"}}},
#        {"node"=>{"id"=>"Q2FzdC01NDcyNQ==", "name"=>"石毛翔弥", "person"=>{"nameEn"=>"", "nameKana"=>"いしげしょうや"}, "character"=>{"name"=>"五条新菜", "nameKana"=>"ごじょうわかな"}}}]},
#    "staffs"=>{"edges"=>[{"node"=>{"name"=>"福田晋一", "roleText"=>"原作", "sortNumber"=>0}}, {"node"=>{"name"=>"篠原啓輔", "roleText"=>"監督", "sortNumber"=>10}}]}}},
# {"node"=>