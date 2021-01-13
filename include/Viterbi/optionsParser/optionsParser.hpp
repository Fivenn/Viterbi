#ifndef TOOLS_OPTIONSPARSER_HH
#define TOOLS_OPTIONSPARSER_HH

#include <ostream>
#include <string>
#include <vector>

#include <boost/algorithm/string/replace.hpp>
#include <boost/preprocessor.hpp>
#include <boost/program_options.hpp>

namespace bpo = boost::program_options;

/**
 * @page OptionParser Options parser
 *
 * @section Features
 *
 * - non intrusive: every modules can define their own options without modifying
 * your main() function
 * - easy to use
 *
 * @code
 * #include <OptionsParser.hh>
 *
 * // the following declaration will add:
 * //  - a new option call `nb-site` in the group `grp`
 * //  - use "" if you don't want to put the option in a group
 * //  - a new Variable int32_t ARG_nb_site with the default value 53;
 * ADD_OPTION("grp", nb_site, "desc", int32_t, 53)
 *
 * // the following declaration will add:
 * //  - a new option call `site-list` in the group `grp`
 * //  - use "" if you don't want to put the option in a group
 * //  - a new Variable vector<int32_t> ARG_site_list empty by default;
 * ADD_OPTION_MULTI("grp", site_list, "desc", int32_t)
 *
 * // the following declaration will add:
 * //  - ARG_enable_xyz, which is a bool value which will be set to 1
 * //    if --enable-xyz option is found
 * ADD_SWITCH("grp", enable_xyz, "desc")
 *
 * MANDATORY_OPTION(toto)
 *
 * int main(int argc, char ** argv)
 * {
 *   TOOLS_PARSE_OPTIONS(argc, argv);
 *   return 0;
 * }
 * @endcode
 */

/**
 * the macro CALL_BEFORE_MAIN() is used to write call which will be executed
 * before main() is called :
 *
 * @code
 * CALL_BEFORE_MAIN(Jojo)
 * {
 *   puts("hello, world! (before main())");
 * }
 * @endcode
 */
#define CALL_BEFORE_MAIN(Salt)             \
  static void __attribute__((constructor)) \
      BOOST_PP_CAT(BOOST_PP_CAT(init_, __LINE__), _##Salt)()

namespace Tools {
/** @brief The options parser */
class OptionsParser {
 public:
  OptionsParser();

  template <typename T /*void => common*/>
  static inline OptionsParser& instance();

  bpo::options_description& description(const std::string& name = "General");

  inline bpo::positional_options_description& positionalDescription() {
    return positional_description_;
  }

  inline bpo::variables_map& variablesMap();

  inline const bpo::variables_map& variablesMap() const;

  void parse(int argc, char** argv);
  void setMandatory(const std::string& option);
  void showHelp(std::ostream& os, int error_code = 0) const;
  void completeDescription(bpo::options_description& desc) const;

  inline void onOptionsParsed(const boost::function<void()>& callback);
  inline void setErrorCode(int error_code);

 protected:
  typedef std::set<std::string> mandatory_type;
  typedef std::map<std::string, bpo::options_description> descriptions_type;
  typedef std::vector<boost::function<void()> > callbacks_type;

  descriptions_type descriptions_;
  bpo::positional_options_description positional_description_;
  bpo::variables_map variables_map_;
  mandatory_type mandatory_;
  callbacks_type callbacks_;
  int error_code_;
};
}  // namespace Tools

// short macros here
#define TOOLS_GET_OPT_PARSER \
  ::Tools::OptionsParser& opt_parser = ::Tools::OptionsParser::instance<void>()

#define TOOLS_ADD_OPTION \
  TOOLS_GET_OPT_PARSER;  \
  opt_parser.description().add_options()

#define TOOLS_OPTIONS_PARSER_BEGIN2 \
  TOOLS_OPTIONS_PARSER_BEGIN {      \
    ADD_OPTION

#define TOOLS_PARSE_OPTIONS(Argc, Argv)           \
  do {                                            \
    ::Tools::OptionsParser& opt_parser =          \
        ::Tools::OptionsParser::instance<void>(); \
    opt_parser.parse(Argc, Argv);                 \
  } while (0)

/**
 * The _EX variants of the macros allow for a specific name for the
 * variable (not prefixed by ARG_) and for the option. They also allow
 * short variants of the options. Example:
 *
 * ADD_OPTION_EX("grp", "nb_site,n", nbr_of_sites, "desc", int32_t, 53);
 *
 * However, short options are not recommended, due to their ambiguous
 * nature, and the risk of conflicts across modules.
 */

#define _ADD_SWITCH_0(Group, Option, Variable, Desc, FixName)                  \
  bool Variable __attribute__((weak)) = false;                                 \
  namespace {                                                                  \
  CALL_BEFORE_MAIN(Opt##Variable) {                                            \
    std::string name = std::string(Option);                                    \
    if (FixName)                                                               \
      boost::replace_all(name, "_", "-");                                      \
    ::Tools::OptionsParser::instance<void>().description(Group).add_options()( \
        name.c_str(), bpo::bool_switch(&Variable), Desc);                      \
  }                                                                            \
  }

#define ADD_SWITCH_EX(Group, Option, Variable, Desc) \
  _ADD_SWITCH_0(Group, Option, Variable, Desc, false)

#define ADD_SWITCH(Group, Option, Desc) \
  _ADD_SWITCH_0(Group, #Option, ARG_##Option, Desc, true)

#define _ADD_OPTION_0(Group, Option, Variable, Desc, Type, DefaultValue,       \
                      FixName)                                                 \
  Type Variable __attribute__((weak))(DefaultValue);                           \
  namespace {                                                                  \
  CALL_BEFORE_MAIN(Opt##Variable) {                                            \
    std::string name = std::string(Option);                                    \
    if (FixName)                                                               \
      boost::replace_all(name, "_", "-");                                      \
    ::Tools::OptionsParser::instance<void>().description(Group).add_options()( \
        name.c_str(),                                                          \
        bpo::value<Type>(&Variable)->default_value(DefaultValue), Desc);       \
  }                                                                            \
  }

#define ADD_OPTION_EX(Group, Option, Variable, Desc, Type, DefaultValue) \
  _ADD_OPTION_0(Group, Option, Variable, Desc, Type, DefaultValue, false)

#define ADD_OPTION(Group, Option, Desc, Type, DefaultValue) \
  _ADD_OPTION_0(Group, #Option, ARG_##Option, Desc, Type, DefaultValue, true)

#define _ADD_OPTION_MULTI_O(Group, Option, Variable, Desc, Type, FixName)      \
  std::vector<Type> Variable __attribute__((weak))();                          \
  namespace {                                                                  \
  CALL_BEFORE_MAIN(Opt##Variable) {                                            \
    std::string name = std::string(Option);                                    \
    if (FixName)                                                               \
      boost::replace_all(name, "_", "-");                                      \
    ::Tools::OptionsParser::instance<void>().description(Group).add_options()( \
        name.c_str(), bpo::value<std::vector<Type> >(&Variable), Desc);        \
  }                                                                            \
  }

#define ADD_OPTION_MULTI(Group, Option, Desc, Type) \
  _ADD_OPTION_MULTI_O(Group, #Option, ARG_##Option, Desc, Type, true)

#define USE_OPTION(Type, Option) extern Type ARG_##Option

#define _MANDATORY_OPTION_0(Option, FixName) \
  namespace {                                \
  CALL_BEFORE_MAIN(Optm##Option) {           \
    TOOLS_GET_OPT_PARSER;                    \
    std::string name = std::string(#Option); \
    if (FixName)                             \
      boost::replace_all(name, "_", "-");    \
    opt_parser.setMandatory(name);           \
  }                                          \
  }

#define MANDATORY_OPTION_EX(Option) _MANDATORY_OPTION_0(Option, false);

#define MANDATORY_OPTION(Option) _MANDATORY_OPTION_0(Option, true);

#define ADD_MANDATORY_OPTION_EX(Group, Option, Variable, Desc, Type, \
                                DefaultValue)                        \
  ADD_OPTION_EX(Group, Option, Variable, Desc, Type, DefaultValue);  \
  MANDATORY_OPTION_EX(Variable);

#define ADD_MANDATORY_OPTION(Group, Option, Desc, Type, DefaultValue) \
  ADD_OPTION(Group, Option, Desc, Type, DefaultValue);                \
  MANDATORY_OPTION(Option);

#define PRINT_HELP() \
  ::Tools::OptionsParser::instance<void>().showHelp(std::cout, 1)

namespace Tools {
template <typename T>
inline OptionsParser& OptionsParser::instance() {
  static OptionsParser parser;
  return parser;
}

inline bpo::variables_map& OptionsParser::variablesMap() {
  return variables_map_;
}

inline const bpo::variables_map& OptionsParser::variablesMap() const {
  return variables_map_;
}

inline void OptionsParser::onOptionsParsed(
    const boost::function<void()>& callback) {
  callbacks_.push_back(callback);
}

inline void OptionsParser::setErrorCode(int error_code) {
  error_code_ = error_code;
}
}  // namespace Tools

#endif /* !TOOLS_OPTIONSPARSER_HH */
