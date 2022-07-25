# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Examples:

  # movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
  # Character.create(name: 'Luke', movie: movies.first)

Question.destroy_all
Style.destroy_all
Kisetsu.destroy_all
Emotion.destroy_all

question_list = [
  "印象に残ったシーンは？","好きなシーンは？","好きなキャラクターは？","あなたの全体的な評価は？"
]
question_list.each do |i|
  Question.create(question: i)
end


season_list = [
  "All","春","夏","秋","冬","不定期"
]
season_list.each_with_index do |i,c|
  Kisetsu.create(name: i,id:c+1)
end

Style.create(name: "アニメ")
Style.create(name: "映画")

# emotions

emotion_list = [
"感動",
"幸福",
"愛しさ",
"かわいさ",
"魅力",
"憧憬(憧れ)",
"共感",
"親近感",
"同情",
"哀れみ",
"リラックス",
"冷静",
"安心",
"不安",
"敗北感",
"落胆",
"孤独",
"無念",
"苦しみ",
"悲しみ",
"切なさ",
"寂しさ",
"空虚",
"意気消沈",
"驚愕(驚き)",
"衝撃",
"緊張感",
"スリル",
"絶望",
"恐怖",
"パニック",
"興奮",
"焦燥(焦り)",
"悔しさ",
"困惑",
"怒り",
"嫉妬",
"羞恥心",
"嫌悪",
"軽蔑",
"憎悪(憎しみ)",
"いらだち",
"フラストレーション",
]

emotion_list.each do |i|
  Emotion.create(emotion: i)
end




# 覚醒
# 勇気
# 期待
# 希望
# 尊敬
# 満足
# 楽しい
# 熱中
# 残念
# 後悔
# 不満
# 失望
# 諦念 (諦め)











