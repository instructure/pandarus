
To generate Ruby code from the api-docs.json, accompanying json files, and
this project's ruby template files:

mvn clean package scala:run -Dlauncher=ruby-codegen

(requires Java 1.7, may work on 1.6 but OOM errors have cropped up)