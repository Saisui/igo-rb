require 'jisho_api'
require 'jieba_rb'

module Igo
  Jisho = JishoAPI::JishoAPI
  module Ja
  end
  module Zh
  end
end

include Natlang
