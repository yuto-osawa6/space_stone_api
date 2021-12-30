# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# 実行済み２
Question.destroy_all

# 実行済み
question_list = [
  "印象に残ったシーンは？","好きなシーンは？","好きなキャラクターは？","あなたの全体的な評価は？"
]
question_list.each do |i|
  Question.create(question: i)
end
