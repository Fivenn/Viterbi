/**
 * @file   vocabulary.cpp
 * @Author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date   December, 2015
 * @brief  vocabulary management
 */

#include "useful/text_proc.hpp"

#include "viterbi/vocabulary.hpp"

using namespace viterbi;

/********************************************************************/
/* Vocabulary                   			            */
/********************************************************************/

const std::string Vocabulary::UNK_STR = "__UNK__";     ///< Unknow element
const std::string Vocabulary::ANY_STR = "__ANY__";     ///< Wildcard element
const std::string Vocabulary::EMPTY_STR = "";          ///< Empty element
const std::string Vocabulary::FILLER_STR = "__FIL__";  ///< Filler element

VocId Vocabulary::add_voc(const std::string& elem, bool nocheck) {
  if (!nocheck) {
    auto it = strToArrayId.find(elem);
    if (it != strToArrayId.end()) {
      return it->second;
    }
  }
  // else add a new voc
  VocId vid = static_cast<VocId>(vocArray.size());
  vocArray.emplace_back(elem);
  strToArrayId[elem] = vid;

  return vid;
}

std::vector<VocId> Vocabulary::add_utterance(const std::string& utt) {
  std::vector<VocId> tokens;
  tokens.reserve(utt.size() / 3);  // 3 char per word on average
  std::istringstream iss(utt);

  // Faster than parser !
  std::transform(std::istream_iterator<std::string>(iss),
                 std::istream_iterator<std::string>(), back_inserter(tokens),
                 [this](const std::string& w) -> VocId { return add_voc(w); });

  // mcsase::useful::text_processing::ParseToWords parser(&iss);
  // parser.apply_on_termes(
  //     [&tokens, this](std::string w) { tokens.push_back(this->add_voc(w)); },
  //     [](std::string) {}, []() {});

  tokens.shrink_to_fit();
  return tokens;
}

VocId Vocabulary::get_vocId(const std::string& elem) {
  return strToArrayId[elem];
}

const std::string& Vocabulary::get_voc(VocId id) {
  if (id >= 0 && id < static_cast<VocId>(vocArray.size())) {
    return vocArray[static_cast<size_t>(id)];
  } else {
    switch (id) {
      case Vocabulary::UNK:
        return Vocabulary::UNK_STR;
      case Vocabulary::ANY:
        return Vocabulary::ANY_STR;
    }
  }
  return Vocabulary::UNK_STR;
}

std::string Vocabulary::to_utterance(std::vector<VocId> va,
                                     const std::string& sep) {
  switch (va.size()) {
    case 0:
      return "";
    default:
      std::ostringstream os;
      auto it = va.begin();
      os << get_voc(*it);
      for (++it; it != va.end(); ++it) {
        os << sep << get_voc(*it);
      }
      return os.str();
  }
}

bool Vocabulary::is_unk(VocId id) {
  return id == Vocabulary::UNK;
}

bool Vocabulary::is_any(VocId id) {
  return id == Vocabulary::ANY;
}

bool Vocabulary::is_empty(VocId id) {
  return id == Vocabulary::EMPTY;
}

bool Vocabulary::is_filler(VocId id) {
  return id == Vocabulary::FILLER;
}
