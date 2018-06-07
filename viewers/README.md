# Providing views of ESSGLOBAL

Here are some tools to provide views of the ESSGLOBAL vocabulary.

## Viewing SKOS data as simple lists

We have a need to extract simple lists from the SKOS definitions.

The raw SKOS data can be grabbed using curl. For example:
```
curl -H "Accept: application/rdf+xml" -L http://purl.org/solidarityeconomics/experimental/essglobal/standard/legal-form.skos
```

### Implementation

There are many ways to do this, e.g. using declatative XSLT, or using an XML parser, like ruby nokogiri. 
The ESSGLOBAL vocab is not currently in a triplestore, so SPARQL is not an option at the time of writing.

We've opted to use ruby nokogiri. See `concept-viewer.rb`.

### Examples

The following are example commands to view basic text lists of concepts defined in the SKOS files:
```
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/activities.skos
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/legal-form.skos 
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/products-services.skos 
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/qualifiers.skos 
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/themes.skos 
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby concept-viewer.rb ../vocabs/standard/type-of-labour.skos 
```

Similary, there are tools to generate markdown for each:
```
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby activities-to-md.rb > views/activities.md
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby legal-form-to-md.rb > views/legal-form.md
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby products-services-to-md.rb > views/products-services.md
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby qualifiers-to-md.rb > views/qualifiers.md
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby themes-to-md.rb > views/themes.md
bombyx:~/SEA/essglobal-linked-open-data/map-sse/viewers$ ruby type-of-labour-to-md.rb > views/type-of-labour.md
```
