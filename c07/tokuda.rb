TOKYO_PREFECTURE_ID = 17

def center_address_id
  @_center_address_id ||= center_id
end

def center_id
  center_id = {}
  if prefecture.present?
      center_id['prefecture_id'] = prefecture.id # hogeが都道府県ならhoge
  elsif area.present?
     center_id['area_id'] = area.id # 関東ならhoge
  else
    center_id['prefecture_id'] = @user.try(:employee).try(:prefecture_code).presence || TOKYO_PREFECTURE_ID # hogeが全国ならユーザーが設定している都道府県ユーザーが都道府県を設定してなければ東京
  end
    center_id # 返り値
end


# view
- center_address = info.center_address_id['prefecture_id'].present? ? prefecture_center_addresses[info.center_address_id['prefecture_id'].to_i - 1] : area_center_addresses[info.center_address_id['area_id'].to_i - 1]
