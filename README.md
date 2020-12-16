# map-sse [UNMAINTAINED]

Metadata Application Profile for the Social and Solidarity Economy.

This repository contains the source files for the MAP-SSE (previously referred to as DCAP-SSE). Until October 2016, these were maintained on a server at [essglobal.org](http://essglobal.org/dcap-sse/). A reason for moving them is to allow other people to get involved in the maintenance and development of the MAP-SSE.

Update: as of the end of 2020, this repository is no longer maintained. Instead, see the fork maintained by the [SolidarityEconomyAssociation][1] here:

https://github.com/SolidarityEconomyAssociation/map-sse

[1]: https://github.com/SolidarityEconomyAssociation

## Documentation sources

### ESSGlobal RDF Vocabulary

[ESSGlobal RDF Vocabulary](vocabs/html/essglobal.html) - HTML source view.

_TODO: add link to view in browser_

### ESSGLOBAL Technical Guidelines

[ESSGLOBAL technical guidelines](doc/2014-07-ESSglobal_interop_guidelines.pdf), July 2014.

This is a copy of the [document on the ripess.eu site](http://ripess.eu/wp-content/uploads/2014/07/ESSglobal_interop_guidelines.pdf), retained here for safe keeping.

The Technical Guidelines document describes the reasoning behind the ESSGLOBAL vocab, and the thinking on how it is intended to be used.

### Taxonomy overview

Each taxonomy describes a different facet of an SSE Initiative.

| Taxonomy | Overview (English) | Linked Data definition |
| -------- | ------------------ | --------------- |
| Products and services | [Simple list](viewers/views/products-services.md) | [SKOS](vocabs/standard/products-services.skos) |
| Activities | [Simple list](viewers/views/activities.md) | [SKOS](vocabs/standard/activities.skos) |
| Themes | [Simple list](viewers/views/themes.md) | [SKOS](vocabs/standard/themes.skos) |
| Qualifiers | [Simple list](viewers/views/qualifiers.md) | [SKOS](vocabs/standard/qualifiers.skos) |
| Type of labour | [Simple list](viewers/views/type-of-labour.md) | [SKOS](vocabs/standard/type-of-labour.skos) |
| Legal form | [Simple list](viewers/views/legal-form.md) | [SKOS](vocabs/standard/legal-form.skos) |

Each of these is described in detail in the [ESSGLOBAL technical guidelines](doc/2014-07-ESSglobal_interop_guidelines.pdf).


## Generating and deploying RDF serializations

There is a [script](generators/build) for generating various RDF serialializations.
For more information, see the [generating and deploying serializations](https://github.com/essglobal-linked-open-data/map-sse/wiki/Generating-and-deploying-serializations) in the Wiki.

## Release versions

### V1.0 (git tag `v1.0`)

Consists of `.ttl`, `.rdf` and `.skos` files copied from the `essglobal.org` server.

| File type | Origin on essglobal.org |
| --------- | ----------------------- |
| `.ttl`, `.rdf` | `vocabs/vocab/v1.0` |
| `.skos` | `vocabs/standard` |

### V1.1 (git tag `v1.1`)

Consists of `.ttl` and `.rdf` copied from the `essglobal.org` server.

| File type | Origin on essglobal.org |
| --------- | ----------------------- |
| `.ttl`, `.rdf` | `vocabs/vocab/v1.1` |
| `.skos` | unchanged |

## Use of branches in this repository

We are following exactly the process documented at http://nvie.com/posts/a-successful-git-branching-model/. Please make sure you are completely familiar with this process before making any changes here. As a consequence of following this branching model:

  - The `master` branch is updated only on release
  - The `develop` branch is the place to look for current activity.
  - The `develop` branch is the default branch for this repository.

Note: when tagging in a local checkout, you must explicitly push tags up to the origin (just as for branches). See [Git Basics -- Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging).
