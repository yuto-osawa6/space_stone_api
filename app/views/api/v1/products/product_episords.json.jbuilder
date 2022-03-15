json.set! :episords do
  json.array! @episords do |a|
    json.id a.id
    json.title a.title
    json.arasuzi a.arasuzi
    json.time a.time
    json.image a.image
    json.release_date a.release_date
    json.episord a.episord

    json.emotions do
      json.array! a.emotions
    end

    json.weeks do
      json.array! a.weeks do |w|
        json.id w.id
      json.week w.week
        json.array w.weeklyrankings
      end
    end

  end
end