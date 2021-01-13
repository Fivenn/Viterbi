/* STD */
#include <time.h>
#include <memory>  // shared pointers

/* viterbi */
#include "useful/various.hpp"

INITIALIZE_EASYLOGGINGPP
const std::string message_OK = "\e[32m[OK]\e[39m";

/* viterbi */
#include "viterbi/viterbi.hpp"

/* Options */
#include "optionsParser/optionsParser.hpp"

ADD_SWITCH("General",
           verbose,
           "Add verbose messages (if cmake called with -DDEBUG=ON).")
ADD_SWITCH("General", quiet, "Only display error messages.")

ADD_OPTION("Data",
           tt,
           "Translation Table filename (moses format)",
           std::string,
           "./test/data/trans0-0.txt")

ADD_OPTION("Input",
           utt,
           "Utterance to translate.",
           std::string,
           "je vous achète un chat blanc")

// Exemple :

int main(int argc, char** argv) {
  /* Parse options */
  TOOLS_PARSE_OPTIONS(argc, argv);

  /* Init Logger */
  useful::config_logger(ARG_verbose, ARG_quiet);

  auto voc = std::make_shared<viterbi::Vocabulary>();

  LOG(INFO) << "Loading Translation Table: " << ARG_tt;
  viterbi::TranslationTable tt(voc);
  tt.load(ARG_tt);

  std::cout << tt << std::endl;

  viterbi::Utterance utt(ARG_utt, voc); // TODO: change to shared pointer
  LOG(INFO) << "Translation of \"" << utt << "\"";

  /* Main */
  viterbi::Viterbi v(voc);
  std::cout << v.translate(utt, tt) << std::endl;

  return 0;
}