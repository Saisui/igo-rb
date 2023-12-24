require 'nokogiri'
require 'open-uri'
require 'uri'

module Igo

  # ## 使い方 :: Usage / Ja
  #
  #   require 'igo'
  #   require 'igo/ja'
  #
  #   j = Igo::Ja
  #
  #   cutted = j.cut "あー、合成は結合法則を満たすんでしたね"
  #   #=> ["あー", "、", "合成", "は", "結合法則", "を", "満たす", "ん", "でした", "ね"]
  #
  #   cutted = j.cut "あー、合成は結合法則を満たすんでしたね", s: true
  #   #=>  "あー 、 合成 は 結合法則 を 満たす ん でした ね"
  #
  # 下ノ関数は、暫く未完成です、ごめんね：
  #
  # `j.romaji`, `j.kana`, `j.tag`。
  #
  module Ja

    SEARCH_URL = "https://jisho.org/search/"

    class << self
      # ## 使い方 :: Usage / Ja
      #
      #   j = Igo::Ja
      #
      #   cutted = j.cut "あー、合成は結合法則を満たすんでしたね"
      #   #=> ["あー", "、", "合成", "は", "結合法則", "を", "満たす", "ん", "でした", "ね"]
      #
      #   cutted = j.cut "あー、合成は結合法則を満たすんでしたね", s: "/"
      #   #=>  "あー/、/合成/は/結合法則/を/満たす/ん/でした/ね"
      #
      def cut str, s: false
        str = URI.encode_www_form_component(str)
        doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)
        cutted = doc.css(".japanese_word__text_wrapper").map{_1.text.strip}
        # s ? cutted.join(s) : cutted
        sep = s.is_a?(String) ? s : " "
        s ? cutted.join(sep) : cutted
      end
      # def romaji str
      # end

      # def kana str
      # end
    end

    # TODO: tag word function
    #
    def tag str, s: false, ns: 0
      # TODO
    end

  end


  class << self
    def 日本語
      Ja
    end
  end
end
