#
# キャラダイス
#

require 'io/console'
require 'yaml'

# パラメータ群
PARAMETERS = {
  vit: '生命力',
  mnd: '精神力',
  str: '筋力',
  int: '知力',
  dex: '器用さ',
  agi: '敏捷性',
}
MAX_POINT = 10

# ダイスふる本体
def roll
  {}.tap do |data|
    PARAMETERS.keys.each do |param|
      data[param] = rand(MAX_POINT) + 1
    end
  end
end

try_count = 0
actor_data = nil
until(actor_data) do
  tmp_data = roll

  puts "===== パラメータ(試行 #{try_count+=1} 回目) ====="
  PARAMETERS.each do |param, param_name|
    puts "#{param_name}: #{tmp_data[param]}"
  end
  print "\n確定する？(y/N)> "
  puts c = STDIN.getch
  if c.downcase == 'y'
    actor_data = tmp_data
  elsif c == "\u0003"
    # TODO: 終了方法の見直し(getchでの入力待機は Ctrl+C = U+0003 入力でのInterruptが発生しない)
    raise Interrupt
  end
p c
end

char_name = nil
until(char_name) do
  print "キャラクター名を入力> "
  char_name = gets.rstrip
  unless char_name.length >= 1
    puts "  error: キャラクター名は1文字以上入力してください"
    char_name = nil
  end
end

sheet = {
  name: char_name,
  status: actor_data,
}
filepath = "#{char_name.gsub(/\s+/, '_')}.yml"
File.write(filepath, sheet.to_yaml)

puts "#{filepath} として保存されました"
