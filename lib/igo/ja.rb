require 'jisho_api'
require 'nokogiri'
require 'open-uri'


module Igo
  module Jisho

    SEARCH_URL = "https://jisho.org/search/"

    class << self
      def cut str, s: false
        doc = Nokogiri::HTML(URI.open(SEARCH_URL + str).read)
        cutted = doc.css(".japanese_word__text_wrapper").map{_1.text.strip}
        s ? cutted.join(" ") : cutted
      end
      # def romaji str
      # end

      # def kana str
      # end
    end
  end

  Ja = Jisho

  class << self
    def 日本語
      Ja
    end
  end
end
