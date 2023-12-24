require 'nokogiri'
require 'open-uri'
require 'uri'

module Igo
  module Ja

    SEARCH_URL = "https://jisho.org/search/"

    class << self
      def cut str, s: false
        str = URI.encode_www_form_component(str)
        doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)
        cutted = doc.css(".japanese_word__text_wrapper").map{_1.text.strip}
        s ? cutted.join(" ") : cutted
      end
      # def romaji str
      # end

      # def kana str
      # end
    end

    def tag str, s: false, ns: 0

    end

  end


  class << self
    def 日本語
      Ja
    end
  end
end
