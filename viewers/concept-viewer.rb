require 'nokogiri'

# Provide a filename as an argument to this script.
# e.g. ../vocabs/standard/legal-form.skos
doc = Nokogiri::XML(ARGF.read) do |config|
  config.strict.noblanks
end

concepts = doc.css('skos|Concept')

def get_text_for(container, tag, lang)
  opts = container.css(tag)
  candidate = nil
  opts.each {|p|
    if p["xml:lang"].upcase == lang.upcase && !p.text.strip.empty?
      candidate = p
    end
  }
  candidate
end
concepts.each {|c|
  prefLabel = get_text_for(c, 'skos|prefLabel', 'EN')
  definition = get_text_for(c, 'skos|definition', 'EN')

  cols = [prefLabel, definition].compact.map { |x|
    x.text
  }.uniq
  puts cols.join(",")
}
