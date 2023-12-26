require 'nokogiri'
require 'open-uri'
require 'uri'
require 'concurrent'
require 'timeout'
require 'romaji'

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
        # str = URI.encode_www_form_component(str)
        # doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)
        # cutted = doc.css(".japanese_word__text_wrapper").map{_1.text.strip}
        # # s ? cutted.join(s) : cutted
        # sep = s.is_a?(String) ? s : " "
        # s ? cutted.join(sep) : cutted

        tag(str, s: s, kana: false, tag: false)
      end

      private def _romaji str
        Romaji.kana2romaji str
      end
      # def kana str
      # end
      def kana str, s: false, lr: "（）"
        # str = URI.encode_www_form_component(str)
        # doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)

        # cutted = doc.css(".japanese_word__furigana, .japanese_word__text_wrapper").select{_1.css(".japanese_word__text_with_furigana").empty?}
        # cutted = cutted.map do kanji = _1.attr("data-text")
        #   (kanji.nil? or kanji.empty?) ? [_1.text] : [kanji, _1.text]
        # end

        # if s
        #   unless s.is_a?(String)
        #     s = " "
        #   end
        #   cutted.map(&:last).join(s)
        # else cutted.map(&:last)
        # end

        tag(str, s: s, lr: lr, tag: false, kana: true, kana_only: true)
      end

      def ruby str, s: false, lr: "（）", romaji: false
        # str = URI.encode_www_form_component(str)
        # doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)

        # cutted = doc.css(".japanese_word__furigana, .japanese_word__text_wrapper").select{_1.css(".japanese_word__text_with_furigana").empty?}
        # cutted = cutted.map do kanji = _1.attr("data-text")
        #   (kanji.nil? or kanji.empty?) ? [_1.text] : [kanji, _1.text]
        # end

        # if s
        #   unless s.is_a?(String)
        #     s = " "
        #   end
        #   left, right = case lr
        #   when String then (lr*2).split("").values_at(0, -1)
        #   when Array then lr
        #   end
        #   cutted.map{ _1.size >= 2 ? _1[0]+left+_1[1]+right : _1[0] }.join(s)
        # else cutted
        # end

        tag str, s: s, lr: lr, kana: true, tag: false, romaji: romaji

      end
      # TODO: tag word function
      #
      def romaji str, s: false
        tag str, s: s, romaji: true, kana_only: true, tag: false
      end

      def tag str, s: false, ns: 0, lr: "（）", sp:"_", short: false, tag: true, kana: false, timeout: 10, kana_only: false, romaji: false

        def async_query(arr, timeout=0, &block)
          promises = arr.map do |element|
            Concurrent::Promise.execute do
              begin
                Timeout.timeout(timeout) do # 设置最大执行时间为5秒
                  block.call(element)
                end
              rescue Timeout::Error
                # 处理超时异常
                puts "任务执行超时, #{timeout} 秒！关键词参数 timeout: 指定超时秒数！"
                nil
              end
            end
          end

          # 等待所有任务完成
          results = promises.map(&:value!)

          # 获取结果数组
          results
        end

        def _tag str, romaji: false
          str = URI.encode_www_form_component(str)
          doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)

          cutted = doc.css(".japanese_word")
          .map do
            text = _1.css(".japanese_word__text_wrapper, japanese_word__text_wrapper").text.strip
            kn = _1&.css(".japanese_word__furigana").text
            cat = _1.attr("data-pos")

            romj = kn.empty? ? _romaji(text) : _romaji(kn)

            [text, # text
            romaji ? romj : kn , # romaji || kana || ""
            cat] # tag || nil
          end
        end

        def _stringify cutted, s: "/", lr: "（）", sp:"_", short: false, vis_tag: true, vis_kana: true, kana_only: false, romaji: false
          # cutted.each{ _1[1] = nil } unless vis_kana
          # cutted.each{ _1[2] = nil } unless vis_tag
          if kana_only
            return cutted.map do
              (_1[1].empty? ? _1[0] : _1[1]) +
              ((vis_kana && _1[2]) ? (sp + _1[2]) : "")
            end.join(s)
          else
            unless s.is_a?(String)
              s = " "
            end
            left, right = case lr
            when String then (lr*2).split("").values_at(0, -1)
            when Array then lr
            end
            cutted.map do
              _1[0] +
              ((vis_tag && !_1[1]&.empty? )? (left + _1[1] + right) : "") +
              ((vis_kana && _1[2]) ? (sp + _1[2]) : "")
            end.join(s)
          end
        end

        def singo_proc str, s: false, ns: 0, lr: "（）", sp:"_", short: false, vis_tag: true, vis_kana: true, kana_only: false, romaji: false
          cutted = _tag str, romaji: romaji
          if short
            short = short.is_a?(Integer) ? short : 4
            cutted = cutted.map{[ *_1[0,2],      (_1[2][0, short].downcase rescue nil)   ]}
          end

          if s
            _stringify cutted, s: s, lr: lr, sp: sp, short: short, vis_tag: vis_kana, vis_kana: vis_tag, kana_only: kana_only, romaji: romaji
          else
            cutted = cutted.map{_1.values_at(* [0, vis_kana ? 1 : 0, vis_tag ? 2 : 0].uniq)}
            cutted[0].size == 1 ? cutted.flatten : cutted
          end
        end

        case str
        when String
          singo_proc str, s: s, ns: ns, lr: lr, sp: sp, short: short, vis_tag: tag, vis_kana: kana, kana_only: kana_only, romaji: romaji
        when Array
          async_query str, timeout do
            singo_proc _1, s: s, ns: ns, lr: lr, sp: sp, short: short, vis_tag: tag, vis_kana: kana, kana_only: kana_only, romaji: romaji
          end
        end
        # TODO
      end
    end
  end


  class << self
    def 日本語
      Ja
    end
  end
end
