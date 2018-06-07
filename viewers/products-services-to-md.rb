require_relative 'concepts'

category = "products-services"
local_file = "../vocabs/standard/#{category}.skos"
url = "http://purl.org/solidarityeconomics/experimental/essglobal/standard/#{category}.skos"
lang = "EN"
concepts = ESSGLOBAL.Concepts(local_file, lang)

puts ESSGLOBAL.markdown_header(category, lang, url)

concepts.each {|c|
  if c[:prefLabel].nil? || c[:prefLabel] == c[:definition]
    puts "### #{c[:definition]}"
  else
    puts "- #{c[:definition]}" 
  end
}



