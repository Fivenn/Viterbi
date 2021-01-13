/**
 * @file   utterance.cpp
 * @Author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date   July, 2017
 * @brief  Utterance management
 */

#include "viterbi/utterance.hpp"

using namespace viterbi;

/********************************************************************/
/* Utterance                          			            */
/********************************************************************/

Utterance::Utterance(std::shared_ptr<Vocabulary>& v) : voc(v) {
  data.clear();
}

Utterance::Utterance(const std::string& text, std::shared_ptr<Vocabulary>& v)
    : voc(v) {
  data = voc->add_utterance(text);
}

void Utterance::add_word(const std::string& w) {
  data.push_back(voc->add_voc(w));
}

void Utterance::add_word_id(const VocId& w) {
  data.push_back(w);
}

VocId Utterance::get_word_id(size_t pos) const {
  return data[pos];
}

void Utterance::clear() {
  data.clear();
}

size_t Utterance::size() const {
  return data.size();
}

// const std::vector<VocId>& Utterance::get_data() const { return data; }

namespace viterbi {
std::ostream& operator<<(std::ostream& os, const Utterance& utt) {
  os << utt.voc->to_utterance(utt.data);

  return os;
}

}  // End Namespace viterbi
