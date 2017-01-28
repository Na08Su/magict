class PagesController < ApplicationController
  def about
  end

  def landing
    render :layout => false
    # @users = User.all

    # @user = User.new
    # puts @user.nil?
  end

  def javasc_pra
    # yes OR no　の2択で例外を出さないようにする

    # uranai_table ={
    #   'Q1' => ['Q2', 'Q3'],
    #   'Q2' => ['A1', 'Q4'],
    #   'Q3' => ['Q4', 'Q5'],
    #   'Q4' => ['A2', 'Q6'],
    #   'Q5' => ['Q6', 'A4'],
    #   'Q6' => ['A3', 'A5'],
    # }

    # # 結果を定義
    # kekka = {
    #   'Q1' => '静(1)か動(2)ならどちらを選ぶ?',
    #   'Q2' => 'コーヒー(1)か紅茶(2)ならどちらを選ぶ?',
    #   'Q3' => '記号(1)か言語(2)どちらを選ぶ?',
    #   'Q4' => 'カレーは大好き(1)かそうでもない?(2)',
    #   'Q5' => '規律(1)か自由(2)どちらが重要?',
    #   'Q6' => '古いものに価値を見出す?はい(1)いいえ(2)',
    #   'A1' => '次はJavaを勉強してみよう!',
    #   'A2' => 'Haskelが待っています',
    #   'A3' => 'Lispやってみたら?',
    #   'A4' => 'あなたはRubyの子です',
    #   'A5' => 'pythonもおすすめ!',
    # }

    # # 最初の状態を定義
    # @state = "Q1"
    # # 無限ループ
    # #while @state[0] == 'Q' # Aになるまで繰り返す
    #   #@response = kekka[@state] # 現在の状態に対応したメッセージを表示
    # #   @state = uranai_table[@state][gets().to_i()] || uranai_table[@state][0] # 入力された数字 || (Q1に戻る)
    #                                  #　ここに1か2が入るようにすれば良い
    # #end

    # @result = kekka[@state] # 結果を出力
  end

  def angular_pra
        render :layout => false


  end

end

