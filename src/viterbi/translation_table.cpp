
#include "viterbi/translation_table.hpp"

#include "easylogging++/easylogging++.hpp"

#include <fstream>  // files
#include <math.h> // log

/********************************************************************/
/* TRULE                          			            */
/********************************************************************/

namespace viterbi {
std::ostream& operator<<(std::ostream& os, const TRule& t) {
  os << "" << t.voc->to_utterance(t.source) << " ||| "
     << t.voc->to_utterance(t.translation) << " ||| " << t.cost;

  return os;
}
}  // namespace viterbi

/********************************************************************/
/* TranslationTable                          			            */
/********************************************************************/

const std::string viterbi::TranslationTable::MOSES_DELIM = "|||";
const std::string viterbi::TranslationTable::MOSES_FEATURE_DELIM = " ";

viterbi::TranslationTable::TranslationTable(std::shared_ptr<Vocabulary>& voc)
    : voc(voc) {}

void viterbi::TranslationTable::load_line(std::string& line) {
  size_t pos = 0;
  TRule r;
  r.voc = voc;

  std::string token;
  int field = 1;
  while ((pos = line.find(MOSES_DELIM)) != std::string::npos) {
    token = line.substr(0, pos);
    // Process token
    switch (field) {
      case 1:
        // Source
        r.translation = voc->add_utterance(token);

        break;
      case 2:
        // Target
        r.source = voc->add_utterance(token);
        break;
      default:  // ignored
        break;
    }
    // Next field
    line.erase(0, pos + MOSES_DELIM.length());
    ++field;
  }
  if (field == 3) {
    // parse cost (first double of the line)
    std::stringstream ss(line);
    ss >> r.cost;
    r.cost = log(r.cost);
    tPhrases.emplace(r.source, r);
  }
}

void viterbi::TranslationTable::load(const std::string& filename) {
  std::ifstream file(filename.c_str());
  if (!file.is_open()) {
    LOG(FATAL) << "Can't open file \"" << filename << "\". Error: " << errno;
  }

  /* load file and build paraphrases */
  while (!file.eof()) {
    std::string line;
    getline(file, line);

    load_line(line);
  }

  /* free ressources */
  file.close();
}

std::vector<viterbi::TRule> viterbi::TranslationTable::get_rules(
    const std::vector<VocId>& search) {
  std::vector<viterbi::TRule> res;

  auto itRange = tPhrases.equal_range(search);
  for (auto it = itRange.first; it != itRange.second; ++it) {
    res.push_back(it->second);
  }
  return res;
}

namespace viterbi {
std::ostream& operator<<(std::ostream& os, const TranslationTable& tt) {
  for (const auto& p : tt.tPhrases) {
    os << p.second << std::endl;
  }
  return os;
}
}  // namespace viterbi
