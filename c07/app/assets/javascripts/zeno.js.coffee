$ ->
  # モーダル用設定 start #####
  $(document).on 'click', '.modal-button', ->
    target = $(this).data('target')
    $('html').addClass('is-clipped')
    $(target).addClass('is-active')

  $(document).on 'click', '.modal-background, .modal-close', ->
    $('html').removeClass('is-clipped')
    $(this).parent().removeClass('is-active')

  $(document).on 'click', '.modal-card-head .delete, .modal-card-foot .button', ->
    $('html').removeClass('is-clipped')
    $('#modal-ter').removeClass('is-active')
  # モーダル用設定 end #####

  # flatpickr(datetime_picker)用 設定 start #####
  Flatpickr.localize('ja')
  Flatpickr.defaultConfig.time_24hr = true
  Flatpickr.defaultConfig.dateFormat = 'Y/m/d'
  Flatpickr.defaultConfig.allowInput = true

  # 8/8, 9/21 等で入力された場合にYYYY/MM/DDに変換する
  # 変換できない場合はnullにする
  $(document).on 'change', '.datetime-picker', ->
    str = moment($(this).val(), ['YYYY/MM/DD', 'MM/DD']).format('YYYY/MM/DD')
    $(this).val( (if str == 'Invalid date' then '' else str) )
  # flatpickr(datetime_picker)用 設定 end #####

  # Turbolinksでリンク遷移した際に、$(document).on 'ready'が発火しない
  # 遷移毎に発火させたい場合は、この下に記述する
  #
  $(document).on 'turbolinks:load', ->
    $(document).trigger('refresh_autonumeric')
    $('.datetime-picker').flatpickr()

    $('.change-action-button').on 'click', ->
      # 出力ボタンだけlink_toにしているのは、submitボタンだと自動でdisabledが設定されてしまい、続けて検索ができなくなってしまうため
      form = this.closest('form')
      form.action = this.dataset.actionUrl
      form.submit()

  # NestedFormの子が追加された時のトリガー
  $(document).on 'nested:fieldAdded', ->
    $(document).trigger('refresh_autonumeric')

  # HtmlEscape関数 usage. escapeHtml(val)
  window.escapeHtml = do (String) ->
    escapeMap =
      '&': '&amp;'
      '\'': '&#x27;'
      '`': '&#x60;'
      '"': '&quot;'
      '<': '&lt;'
      '>': '&gt;'
    escapeReg = '['
    reg = undefined
    for p of escapeMap
      if escapeMap.hasOwnProperty(p)
        escapeReg += p
    escapeReg += ']'
    reg = new RegExp(escapeReg, 'g')
    (str) ->
      str = if str == null or str == undefined then '' else '' + str
      str.replace reg, (match) ->
        escapeMap[match]

  # 指定要素に値をセットし、カンマ区切りにする
  window.setDelimitedNumber = (element, num) ->
    e = $(element) # jQueryオブジェクトに変換
    e.autoNumeric('init', { mDec: 0, aForm: false })
    e.autoNumeric('set', num)

  # 消費税を計算 gonにtax_rateが定義されている事が条件
  window.calcTaxAmountBinding = (observe_name, target_name, name_prefix) ->
    prefix = name_prefix ? { nameprefix : '' }

    $(document).on 'change', '#' + prefix + '_' + observe_name, ->
      target = $('#' + prefix + '_' + target_name)
      setDelimitedNumber(target, Math.round(Number($(this).val().replace(/,/g, '')) * gon.tax_rate))

  # selectタグの要素を入れ替え
  # optionsは、{ id: ***, name: *** }の配列を渡す
  window.replaceSelectOptions = (select_element, options, include_blank) ->
    target = $(select_element)
    target.empty()

    if typeof (include_blank) == "string" || include_blank instanceof String
      target.append($('<option />')).text(include_blank)

    $(options).each (index) ->
      target.append $('<option>').val(this.id).text(this.name)
      return

  # 小数点n位までを残す関数
  # number: 対象の数値
  # n: 残したい小数点以下の桁数
  window.floatFormat = (number, n) ->
    _pow = 10 ** n
    Math.round(number * _pow) / _pow

  jQuery.extend
    # selectorの要素の値をsumする
    # input属性でないと使用できません
    # ex. $.sum('.amount input[type=text]')
    sum: (selector) ->
      sum = 0
      jQuery(selector).each ->
        value = parseInt($(this).val().replace(/,/g, ''))
        if !isNaN(value)
          sum += value
        return
      sum
