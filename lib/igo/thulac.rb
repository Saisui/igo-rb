require 'pycall/import'

module Thulac
  PyCall.exec("import thulac")
  PyCall.exec("thulac1 = thulac.thulac()")
end
class << Thulac
  def cut str, text: false
    text = text ? "True" : "False"
    PyCall.eval(<<-EOF
      thulac1.cut(#{str.inspect}, text=#{text})
    EOF
    )
  end
end
