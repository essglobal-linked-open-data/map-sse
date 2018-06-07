require 'nokogiri'

doc = Nokogiri::XML(File.open("../vocabs/standard/legal-form.skos")) do |config|
  config.strict.noblanks
end

concepts = doc.css('skos|Concept')

concepts.each {|c|
  prefLabels = c.css('skos|prefLabel')
  candidate = nil
  prefLabels.each {|p|
    if p["xml:lang"] == 'EN' && !p.text.empty?
      candidate = p
    end
  }
  if candidate.nil?
    $stderr.puts "Concept without an EN prefLabel"
  else
    puts candidate.text
  end
}
