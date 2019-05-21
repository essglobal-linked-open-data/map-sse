require_relative 'concepts'

category = 'organisational-structure'
local_file = "../vocabs/standard/#{category}.skos"
url = "http://purl.org/solidarityeconomics/experimental/essglobal/standard/#{category}.skos"
lang = "EN"
concepts = ESSGLOBAL.Concepts(local_file, lang)
puts ESSGLOBAL.markdown_header(category, lang, url)

puts concepts.map {|c|
  "- #{c[:prefLabel]}"
}.join("\n")
