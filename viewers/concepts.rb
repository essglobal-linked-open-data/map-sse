require 'nokogiri'
module ESSGLOBAL
  class Internal
    def self.get_text_for(container, tag, lang)
      opts = container.css(tag)
      candidate = nil
      opts.each {|p|
        if p["xml:lang"].upcase == lang.upcase && !p.text.strip.empty?
          candidate = p
        end
      }
      candidate ? candidate.text : nil
    end
  end
  def self.Concepts(file, lang)
    doc = Nokogiri::XML(open(file)) do |config|
      config.strict.noblanks
    end

    concepts = doc.css('skos|Concept')
    concepts.map {|c|
      {
        prefLabel: Internal.get_text_for(c, 'skos|prefLabel', 'EN'),
        definition: Internal.get_text_for(c, 'skos|definition', 'EN')
      }
    }
  end
  def self.markdown_header(category, lang, url)
    <<~HEREDOC
      # ESSGLOBAL

      ## Controlled vocabulary: #{category}
      Further documentation: [ESSGlobal RDF Vocabulary](#{url}).

      List of the preferred labels (in language: #{lang})
    HEREDOC
  end
end

