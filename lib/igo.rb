# frozen_string_literal: true

require_relative "igo/version"
require 'jieba_rb'
require_relative 'igo/zh'
require_relative 'igo/ja'


#
# __AUTHOR__: *saisui* saisui.github.io
#
#    ja.cut "あー、合成は結合法則を満たすんでしたね"
#    #=> ["では", "、", "圏論", "の", "話", "を", "しましょ", "う", "か", "N", "この", "前", "は", "、圏", "について", "紹介 しました"]
#
#    zh.pinyin "床前明月光，疑是地上霜，好了", s: 1
#    #=> chuang2 qian2 ming2 yue4 guang1, yi2 shi4 di4 shang4 shuang1, hao3 le5.
#
#    zh.tag "全世界的无产者，联合起来！", s: true
#    #=> "全世界_n 的_uj 无产者_n ，_x 联合_v 起来_v ！_x"
#

module Igo
  class Error < StandardError; end
  # Your code goes here...
end
