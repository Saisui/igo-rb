require 'ruby_pinyin'

module Igo
  module Zh

    Tagging = JiebaRb::Tagging.new
    Segment = JiebaRb::Segment.new mode: :mix, user_dict: "ext/cppjieba/dict/user.dict.utf8"
    Keyword = JiebaRb::Keyword.new

    # @params chinese: String
    # @returns pinyin_numeraltone: String
    class << self
      def pinyin str, s: false
        res = str.each_char.map{PinYin.of_string(_1, :ascii)}.flatten
        s ? res.join(" ") : res

      end
      def pinyin_tonal_s str
        PinYin.sentence(token, :ascii)
      end
      def pinyin_tonal_a str
        PinYin.of_string(token, :ascii)
      end

      def cut str, s: false, tag: false
        if tag
          s ? Tagging.tag(str).map{_1.to_a.flatten.join("_")}.join(" ") : Tagging.tag(str).map{_1.to_a.flatten}
        else
          res = Segment.cut(str)
          s ? res.join(" ") : res
        end
      end

      def tag str, s: false
        s ? Tagging.tag(str).map{_1.to_a.flatten.join("_")}.join(" ") : Tagging.tag(str).map{_1.to_a.flatten}
      end

      def termfreq string, num
        Keyword.extract string, num
      end

      alias 分词 cut
      alias 标记 tag
      alias freq termfreq
      alias tf termfreq
      alias 词频 freq
      alias freq_word freq
    end
  end
  def self.中文
    Zh
  end

end
