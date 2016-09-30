## 開発環境構築

```
bundle install --path vendor/bundle
```

nokogiriのインストールにこける場合は以下を実行。
```
bundle config build.nokogiri --use-system-libraries
bundle install --path vendor/bundle
```

database.ymlをコピー
```
cp config/database.yml.example config/database.yml
```

Database Create
```
rake db:migrate:reset
```

サンプルデータ投入
```
rake db:seed_fu
```

サーバー起動
```
rails s
```

vagrantの場合
```
bin/rails s -b 0.0.0.0
```

## 利用しているライブラリ
選定基準はなるべく他ライブラリとの依存度が低いもの。(jQuery依存はまぁOK)

### [BulmaCss](http://bulma.io/documentation/overview/start/)

Bootstrap的なCss Framework。 javascriptが一切なく軽量。拡張も結構しやすい・・・と思う。

### [Flatpickr](https://chmln.github.io/flatpickr/)

datetime-picker。

基本的にinput[type=text]のclass属性に`datetime-picker`と書けば動作します。
例外的な使い方で、start, endがありそのRange以外を選ばせたくない場合は以下のように記述.

#### view
```ruby
text_field_tag :start_at
text_field_tag :end_at
```

#### javascript部分
```javascript
var start_at = $('#start_at').flatpickr();
var end_at   = $('#end_at').flatpickr();
start_at.config.onChange = dateObj => end_at.set("minDate", dateObj.fp_incr(1));
end_at.config.onChange = dateObj => start_at.set("maxDate", dateObj.fp_incr(-1));
```

### [Hint.css](http://kushagragour.in/lab/hint/)

ツールチップ。マウスオーバーすると、吹き出し表示してくれるもの。
