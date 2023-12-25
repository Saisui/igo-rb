# 言語 :: Igo

[🌏](README.md) | [中文](README.zh.md) | [English](README.en.md) | [日本語](README.ja.md)

Support `zh-CN`, `ja-JP`

```ruby
cutted = j.cut "あー、合成は結合法則を満たすんでしたね"
#=> ["あー", "、", "合成", "は", "結合法則", "を", "満たす", "ん", "でした", "ね"]

cutted = j.cut "あー、合成は結合法則を満たすんでしたね", s: "/"
#=>  "あー/、/合成/は/結合法則/を/満たす/ん/でした/ね"

```

## Install :: インストール

```cmd
gem install igo
```

for use `Thulac` in __Python__, you need to install:

```cmd

pip install thulac

```

## 使い方 :: Usage / Ja

```ruby
require 'igo'
require 'igo/ja'

j = Igo::Ja

j.cut "あー、合成は結合法則を満たすんでしたね"
#=> ["あー", "、", "合成", "は", "結合法則", "を", "満たす", "ん", "でした", "ね"]

j.kana ["無色で透明な私たちは互いに融合しながらも、", "他方で消えない血液と己の半身を希求する。"], s: "/", lr: "（）"
#=> ["無色（むしょく）/で/透明な（とうめいな）/私たち（わたしたち）/は/互いに（たがいに）/融合し（ゆうごうし）/ながら/も/、", "他方（たほう）/で/消えない（きえない）/血液（けつえき）/と/己（おのれ）/の/半身（はんしん）/を/希求する（ききゅうする）/。"]

j.tag "ゆかりさんが勉強してる圏論に興味を持ったそして", s: "/", kana: 1, short: 4, lr: "[]"

# "ゆかり_prop/さん_suff/が_part/勉強してる[べんきょうしてる]_verb/圏論[けんろん]_noun/に_part/興味[きょうみ]_noun/を_part/持った[もった]_verb/そして_conj"

```

reference:
- UCEjVFAKrcjUWqBnHl_NlacQ - [【圏論】圏の圏を考えたい！そうだ関手を定義しよう！](https://www.youtube.com/watch?v=8ycVEcgH4bI&t=703s)
- ukiyojingu [「無色で透明な私たちは互いに融合しながらも、他方で消えない血液と己の半身を希求する。」](https://www.nicovideo.jp/watch/so40804464) 


下ノ関数は、暫く未完成です、ごめんね：

`j.romaji`

## 用法 :: Usage / Zh

Lack __Trad-Zh__ :: 暂不支持「正體中文」

```ruby
require 'igo'
require 'igo/zh'
z = Igo::Zh
```

### Pinyin :: 拼音

```ruby
z.pinyin "全世界的无产者，联合起来！"
#=> ["quan2", "shi4", "jie4", "de5", "wu2", "chan3", "zhe3", "lian2", "he2", "qi3", "lai2"]
z.pinyin "全世界的无产者，联合起来！", s: 1
#=> "quan2 shi4 jie4 de wu2 chan3 zhe3 lian2 he2 qi3 lai2"

```

### seperate word :: 分词

```ruby
z.cut "全世界的无产者，联合起来！"
#=> ["全世界", "的", "無產階級", "，", "聯合", "起來", "！"]
z.cut "全世界的无产者，联合起来！", s: true
#=> "全世界 的 无产者 ！ 联合 起来 ！"


```
### Taging word :: 标注词类

后续可能添加 `by` 关键词指定函数。

```ruby
z.tag "全世界的无产者，联合起来！"
#=>  [["全世界", "n"], ["的", "uj"], ["无产者", "n"], ["！", "x"], ["联合", "v"], ["起来", "v"], ["！", "x"]]
z.tag "全世界的无产者，联合起来！", s: true
#=> "全世界_n 的_uj 无产者_n ，_x 联合_v 起来_v ！_x"

```
### 词频统计

```ruby
z.freq "全世界的无产者，联合起来！", 5
#=>  [["无产者", 9.96885201925], ["全世界", 6.80147590842], ["联合", 5.64979650728], ["起来", 3.96134044655]]

# alias 拼音, 分词, 标记, 词频

```

## LINCENCE :: 协议

__MPL 2.0__

## Requires

- `jieba-rb`
- `nokogiri`
- `open-uri`
