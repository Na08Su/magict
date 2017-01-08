# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# 画像データの入れ方がめんどくさいからスキップ
# Article 10個
# Article.create( title: 'Ruby学習サイトまとめ', content: '<br> <hr> <p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p><p>がんばるぞおおおおお</p>', image: 'tumblr_o7u5f1fMHK1sfie3io1_1280.jpg')
# Article.create( title: '効率的な勉強方法', content: '<h1>じゃじゃっっじゃじゃ</h1> <p>うまくいけええええええ</p> <b>画像付きです</b>', image: 'tumblr_oea9y5Ics11sfie3io1_1280.jpg')

# User 10人

# Project 5個

# Task10個

# Request 5個