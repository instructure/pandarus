/**
 *  Copyright 2012 Wordnik, Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import com.wordnik.swagger.codegen.BasicRubyGenerator
import java.io.File

object RubyCanvasCodegen extends BasicRubyGenerator {
  def main(args: Array[String]) = generateClient(args)
  
  // to avoid recompiling ...
  override def templateDir = "clients/ruby/template"

  override def apiPackage = Some("pandarus")
  override def modelPackage = Some("pandarus.models")

  override def destinationDir = "clients/ruby/lib"

  override def toApiName(name: String) = name(0).toUpper + name.substring(1)
  override def toModelFilename(name: String) = toUnderscore(name).stripPrefix("_")

  override def typeMapping = Map(
    "float" -> "Float",
    // "long" -> "long",
    "double" -> "Float",
    // "Array" -> "Array",
    // "boolean" -> "bool",
    "string" -> "String",
    "datetime" -> "DateTime"
  )

  override def toVarName(name: String): String = {
    toUnderscore(name).
      replace("-", "_").
      replace("[", "__").
      replace("]", "__").
      replace("*", "x").
      replace("<", "_").
      replace(">", "_")
  }

  override def toMethodName(name: String): String = {
    if (name.isEmpty) "x"
    else toUnderscore(name)
  }

  override def supportingFiles = List(
    // ("canvas_base.mustache", destinationDir + File.separator + apiPackage.get, "canvas_base.rb"),
    // ("monkey.mustache", destinationDir + File.separator + apiPackage.get, "monkey.rb"),
    // ("swagger.mustache", destinationDir + File.separator + apiPackage.get, "swagger.rb"),
    // ("swagger" + File.separator + "configuration.mustache", destinationDir + File.separator + apiPackage.get, "swagger" + File.separator + "configuration.rb"),
    // ("swagger" + File.separator + "response.mustache", destinationDir + File.separator + apiPackage.get, "swagger" + File.separator + "response.rb"),
    // ("swagger" + File.separator + "version.mustache", destinationDir + File.separator + apiPackage.get, "swagger" + File.separator + "version.rb"),
    // ("swagger" + File.separator + "request.mustache", destinationDir + File.separator + apiPackage.get, "swagger" + File.separator + "request.rb")
    ("models.mustache", destinationDir + File.separator + "pandarus", "models.rb")
  )
}