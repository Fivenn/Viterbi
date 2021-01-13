#include <stdlib.h>

#include <iostream>

#include <boost/foreach.hpp>

#include "optionsParser/optionsParser.hpp"

namespace Tools {

ADD_SWITCH("General", help, "Print this help message")

OptionsParser::OptionsParser()
    : descriptions_(),
      positional_description_(),
      variables_map_(),
      mandatory_(),
      error_code_(2) {}

void OptionsParser::showHelp(std::ostream& os, int error_code) const {
  bpo::options_description desc;
  completeDescription(desc);
  desc.print(os);
  os.flush();
  _exit(error_code);
}

bpo::options_description& OptionsParser::description(const std::string& name) {
  descriptions_type::iterator it = descriptions_.find(name);
  if (it != descriptions_.end())
    return it->second;
  it =
      descriptions_.insert(std::make_pair(name, bpo::options_description(name)))
          .first;
  return it->second;
}

void OptionsParser::completeDescription(bpo::options_description& desc) const {
  descriptions_type::const_iterator it = descriptions_.find("General");
  if (it != descriptions_.end())
    desc.add(it->second);
  for (descriptions_type::const_iterator it = descriptions_.begin();
       it != descriptions_.end(); ++it)
    if (it->first != "General")
      desc.add(it->second);
}

void OptionsParser::parse(int argc, char** argv) {
  bpo::options_description desc;
  completeDescription(desc);

  try {
    bpo::store(bpo::command_line_parser(argc, argv)
                   .options(desc)
                   .positional(positional_description_)
                   .run(),
               variables_map_);
  } catch (bpo::error & e) {
    // Nothing
    std::cerr << "Option error: " << e.what() << std::endl;
    showHelp(std::cerr, 2);
  }

  bpo::notify(variables_map_);

  if (ARG_help)
    showHelp(std::cerr);

  if (!variables_map_.count("version") ||
      !variables_map_["version"].as<bool>()) {
    bool error = false;
    for (mandatory_type::iterator it = mandatory_.begin();
         it != mandatory_.end(); ++it) {
      if (variables_map_.count(*it) <= 0 || variables_map_[*it].defaulted()) {
        std::cerr << "error: option `" << *it << "' is mandatory." << std::endl;
        error = true;
      }
    }

    if (error) {
      desc.print(std::cerr);
      exit(error_code_);
    }
  }

  for (callbacks_type::iterator it = callbacks_.begin(); it != callbacks_.end();
       ++it)
    (*it)();
}

void OptionsParser::setMandatory(const std::string& option) {
  mandatory_.insert(option);
}
}  // namespace Tools
