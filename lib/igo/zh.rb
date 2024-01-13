require 'ruby_pinyin'
require 'chinese_convt'


module Igo
  # # 用法 :: Usage / Zh

  # Lack __Trad-Zh__ :: 暂不支持「正體中文」
  #
  # ```ruby
  # require 'igo'
  # require 'igo/zh'
  # z = Igo::Zh
  # ```
  #
  # ### Pinyin :: 拼音
  #
  # ```ruby
  # z.pinyin "全世界的无产者，联合起来！"
  # #=> ["quan2", "shi4", "jie4", "de5", "wu2", "chan3", "zhe3", "lian2", "he2", "qi3", "lai2"]
  # z.pinyin "全世界的无产者，联合起来！", s: 1
  # #=> "quan2 shi4 jie4 de wu2 chan3 zhe3 lian2 he2 qi3 lai2"
  # ```
  #
  # ### seperate word :: 分词
  #
  # ```ruby
  # z.cut "全世界的无产者，联合起来！"
  # #=> ["全世界", "的", "無產階級", "，", "聯合", "起來", "！"]
  # z.cut "全世界的无产者，联合起来！", s: true
  # #=> "全世界 的 无产者 ！ 联合 起来 ！"
  # ```
  # ### Taging word :: 标注词类
  #
  # 后续可能添加 `by` 关键词指定函数。
  #
  # ```ruby
  # z.tag "全世界的无产者，联合起来！"
  # #=>  [["全世界", "n"], ["的", "uj"], ["无产者", "n"], ["！", "x"], ["联合", "v"], ["起来", "v"], ["！", "x"]]
  # z.tag "全世界的无产者，联合起来！", s: true
  # #=> "全世界_n 的_uj 无产者_n ，_x 联合_v 起来_v ！_x"
  # ```
  # ### 词频统计
  #
  # ```ruby
  # z.freq "全世界的无产者，联合起来！", 5
  # #=>  [["无产者", 9.96885201925], ["全世界", 6.80147590842], ["联合", 5.64979650728], ["起来", 3.96134044655]]
  #
  # # alias 拼音, 分词, 标记, 词频
  #
  # ```
  module Zh

    Tagging = JiebaRb::Tagging.new
    Segment = JiebaRb::Segment.new mode: :mix, user_dict: "ext/cppjieba/dict/user.dict.utf8"
    Keyword = JiebaRb::Keyword.new
    HANZI_ORDS = [12295..12295, 13312..19903, 19968..40959, 63744..64255, 131072..173791, 173824..177983, 194560..195103]

    class << self
      # ### Pinyin :: 拼音
      #
      #   z.pinyin "全世界的无产者，联合起来！"
      #   #=> ["quan2", "shi4", "jie4", "de5", "wu2", "chan3", "zhe3", "lian2", "he2", "qi3", "lai2"]
      #   z.pinyin "全世界的无产者，联合起来！", s: " "
      #   #=> "quan2 shi4 jie4 de wu2 chan3 zhe3 lian2 he2 qi3 lai2"
      #
      # @params chinese: String
      # @returns pinyin_numeraltone: String
      def pinyin str, s: false, ommit: " "
        # tone 1, 2, 3, 4, 5

        res = str.split(/(?=[^A-Z\d])|(?<=[^A-Z\d])/i).map do |ch|
            if HANZI_ORDS.map{|range| range.include? ch.ord}.any?
              py = PinYin.sentence(ch, :ascii)
              py == "〇" ? "ling2" : (py =~ /\d/ ? py : (py+"5"))
            else ch
            end
          end.flatten.select{_1 != s and _1 != ommit}

        sep = s.is_a?(String) ? s : " "
        s ? res.join(sep) : res

      end

      def cut str, s: false, tag: false, by: "jieba"
        case by
        when /jieba/
          if tag
            s ? Tagging.tag(str).map{_1.to_a.flatten.join("_")}.join(" ") : Tagging.tag(str).map{_1.to_a.flatten}
          else
            cutted = Segment.cut(str)
            sep = s.is_a?(String) ? s : " "
            s ? cutted.join(sep) : cutted
          end
        when /thulac/
          require_relative 'thulac'
          res = Thulac.cut(str).map(&:first)
          sep = s.is_a?(String) ? s : " "
          s ? res.join(sep) : res
        end
      end

      # ### Taging word :: 标注词类
      #
      # 后续可能添加 `by` 关键词指定函数。
      #
      #   z.tag "全世界的无产者，联合起来！"
      #   #=>  [["全世界", "n"], ["的", "uj"], ["无产者", "n"], ["！", "x"], ["联合", "v"], ["起来", "v"], ["！", "x"]]
      #   z.tag "全世界的无产者，联合起来！", s: true
      #   #=> "全世界_n 的_uj 无产者_n ，_x 联合_v 起来_v ！_x"
      #
      def tag str, s: false, by: 0, sp: "_"
        case by
        when /thu/
          require_relative 'thulac'
          cutted = Thulac.cut(str).to_a.map(&:to_a)
          if s
            s = s.is_a?(String) ? s : " "
            cutted.map{_1.join(sp)}.join(s)
          else cutted
          end
        else
          s ? Tagging.tag(str).map{_1.to_a.flatten.join("_")}.join(" ") : Tagging.tag(str).map{_1.to_a.flatten}
        end
      end

      # ### 词频统计
      #
      #   z.freq "全世界的无产者，联合起来！", 5
      #   #=>  [["无产者", 9.96885201925], ["全世界", 6.80147590842], ["联合", 5.64979650728], ["起来", 3.96134044655]]
      def termfreq string, num
        Keyword.extract string, num
      end

      alias 拼音 pinyin
      alias 分词 cut
      alias 标记 tag
      alias 词频 termfreq

      alias freq termfreq
      alias tf termfreq
      alias freq_word freq

      # 繁体转简体
      def to_chs text
        ChineseConverter.convert(text,  :traditional, :simplified)
      end
      # 简体转繁体
      def to_cht text
        ChineseConverter.convert(text, :simplified, :traditional)
      end
    end
  end
  def self.中文
    Zh
  end

end
