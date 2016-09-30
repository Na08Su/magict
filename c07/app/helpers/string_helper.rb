module StringHelper
  # 全角を2,半角を1とした、文字列の長さを導出
  # @param string 文字列
  def get_exact_size(string)
    string.each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.reduce(0, &:+)
  end

  # 全角文字をカウント
  # @param string 文字列
  def count_multi_byte(string)
    return 0 if string.ascii_only?
    string.each_char.map { |c| c.bytesize == 1 ? 0 : 1 }.reduce(0, &:+)
  end
end
