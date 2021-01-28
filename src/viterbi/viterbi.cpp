#include "viterbi/viterbi.hpp"

#include <algorithm>  // std::min
#include <iostream>
#include <list>
#include <random>
#include <vector>  // std::vector

#include "useful/various.hpp"  // FOR LOG

int64_t random_int(int64_t i);

namespace viterbi {

/********************************************************************/
/* Viterbi node    	      	     	     	     	     	    */
/********************************************************************/

Viterbi::VNode::VNode(std::shared_ptr<Vocabulary>& v, size_t maxHist)
    : bestPath(v), maxHist(maxHist) {
  score = 0;
}

Viterbi::VNode::VNode(const VNode& previous, const TRule& t)
    : bestPath(previous.bestPath), maxHist(previous.maxHist) {
  curHistory.reserve(maxHist);

  std::vector<VocId> prevHistRev(
      previous.curHistory.rbegin(),
      previous.curHistory.rend());  // Copy a reversed previous history
  std::vector<VocId> transRev(
      t.translation.rbegin(),
      t.translation.rend());  // Copy a reversed previous history

  // Add previous history
  size_t nbToBp = prevHistRev.size() + transRev.size();
  if (nbToBp > maxHist) {
    nbToBp -= maxHist;              // Number of tokens to put in bp
    for (; nbToBp > 0; --nbToBp) {  // get in previous history
      if (not prevHistRev.empty()) {
        bestPath.add_word_id(prevHistRev.back());
        prevHistRev.pop_back();
      } else {  // get in current rule
        bestPath.add_word_id(transRev.back());
        transRev.pop_back();
      }
    }
  }

  // add everything remaining in curHistory
  curHistory.insert(curHistory.end(), prevHistRev.rbegin(), prevHistRev.rend());
  curHistory.insert(curHistory.end(), transRev.rbegin(), transRev.rend());

  // Update score
  score =
      update_score(previous.curHistory, previous.score, t.translation, t.cost);

  LOG(DEBUG) << "New node \"" << this->get_utt() << "\" (" << score
             << ") with \"" << t << "\"";
}

Utterance Viterbi::VNode::get_utt() const {
  Utterance res = bestPath;
  for (auto id : curHistory) {
    res.add_word_id(id);
  }
  return res;
}

double Viterbi::VNode::update_score(const std::vector<VocId>&,
                                    double previous,
                                    const std::vector<VocId>&,
                                    double transScore) {
  double score = previous + transScore;
  return score;  // TODO:
}

/********************************************************************/
/* Viterbi    	      	     	     	     	     	    */
/********************************************************************/

Utterance viterbi::Viterbi::translate(const Utterance& utt,
                                      TranslationTable& tt) {
  auto hash = [](const VNode& n) { return VNode::hashByHist(n); };
  auto equal = [](const VNode& n1, const VNode& n2) {
    return VNode::equalByHist(n1, n2);
  };
  typedef std::unordered_set<VNode, decltype(hash), decltype(equal)> VStack;

/* create a stack for each word */
  size_t uLen = utt.size();
  std::list<VStack> stacks;

/* Populate stacks with a start stack */
  stacks.emplace_front(8, hash, equal);
  stacks.front().emplace(voc);

  /* For each stack */
  for (size_t i = 0; i < uLen; ++i) {
    VStack curStack(8, hash, equal);
    std::list<VocId> curCompl;
    size_t back = 0;
    for (auto itStack = stacks.begin(); itStack != stacks.end(); ++itStack, ++back) {
      curCompl.push_front(utt.get_word_id(i - back));
    }
    
  }
  

  LOG(WARNING) << "TODO Viterbi::translate";// TODO:
  return Utterance(voc);
}

}  // namespace viterbi

/********************************************************************/
/* Test    	      	     	     	     	     	    */
/********************************************************************/

int64_t random_int(int64_t i) {
  static std::random_device rd;
  static std::mt19937 rngE(rd());
  static auto gen =
      std::bind(std::uniform_int_distribution<int64_t>(0, i), std::ref(rngE));
  return gen();
}

void viterbi::print_hello() {
  std::cout << "Hello world!" << std::endl;
}

void viterbi::print_rnd_int() {
  std::cout << random_int(100) << std::endl;
}
