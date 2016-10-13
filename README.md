# dcap-sse
Dublin Core Application Profile for the Social and Solidarity Economy.

This repository contains the source files for the DCAP-SSE. Until October 2016, these were maintained on a server at [essglobal.org](http://essglobal.org/dcap-sse/). A reason for moving them is to allow other people to get involved in the maintenance and development of the DCAP-SSE.

## Use of branches in this repository

We are following exactly the process documented at http://nvie.com/posts/a-successful-git-branching-model/. Please make sure you are completely familiar with this process before making any changes here. As a consequence of following this branching model:

  - The master branch is updated only on release
  - The develop branch is the plase to look for current activity.

Note: when tagging in a local checkout, you must explicitly push tags up to the origin (just as for branches). See [Git Basics -- Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging).

## Release versions

### V1.0 (git tag `1.0`)

Consists of `.ttl`, `.rdf` and `.skos` files copied from the `essglobal.org` server.

| File type | Origin on essglobal.org |
| --------- | ----------------------- |
| `.ttl`, `.rdf` | `vocabs/vocab/v1.0` |
| `.skos` | `vocabs/standard` |

### V1.1 (git tag `1.1`)

Consists of `.ttl` and `.rdf` copied from the `essglobal.org` server.

| File type | Origin on essglobal.org |
| --------- | ----------------------- |
| `.ttl`, `.rdf` | `vocabs/vocab/v1.1` |
| `.skos` | unchanged |
