require_relative 'concepts'

category = "qualifiers"
local_file = "../vocabs/standard/#{category}.skos"
url = "http://purl.org/solidarityeconomics/experimental/essglobal/standard/#{category}.skos"
lang = "EN"
concepts = ESSGLOBAL.Concepts(local_file, lang)
puts ESSGLOBAL.markdown_header(category, lang, url)

concepts.each {|c|
  puts "- #{c[:prefLabel]}"
  puts ""
  puts "   #{c[:definition]}"
}
