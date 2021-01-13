#ifndef VITERBI_VITERBI_HPP
#define VITERBI_VITERBI_HPP

#include <algorithm>
#include <functional>  // std::greater
#include <iostream>
#include <queue>
#include <unordered_set>
#include <vector>

#include <boost/functional/hash.hpp>  //boost::hash_value

#include "useful/matrix.hpp"  // Matrix

#include "viterbi/translation_table.hpp"
#include "viterbi/utterance.hpp"
#include "viterbi/vocabulary.hpp"

/**
 * Name space of the project
 */
namespace viterbi {

class Viterbi {
 public:
  Viterbi() = delete;
  Viterbi(std::shared_ptr<Vocabulary> voc, size_t maxHistory = 3)
      : voc(voc), maxHistory(maxHistory){};
  Viterbi(Viterbi const& other) = default;
  Viterbi& operator=(Viterbi const& other) = default;
  Viterbi(Viterbi&& other) = default;
  Viterbi& operator=(Viterbi&& other) = default;
  ~Viterbi() = default;

  Utterance translate(const Utterance& utt, TranslationTable& tt);

 protected:
  std::shared_ptr<Vocabulary> voc;
  size_t maxHistory;

  /* Sub classes */

  class VNode {
   public:
    VNode() = delete;

    VNode(std::shared_ptr<Vocabulary>& v,
          size_t maxHist = 3);                     // build an init node
    VNode(const VNode& previous, const TRule& t);  // compose two nodes

    VNode(VNode const& other) = default;
    VNode& operator=(VNode const& other) = delete;
    VNode(VNode&& other) = default;
    VNode& operator=(VNode&& other) = delete;
    ~VNode() = default;

    Utterance get_utt()const ;

    // Custom Hash Functor that will compute the hash only using curHistory;
    static size_t hashByHist(const VNode& n) {
      return boost::hash_value(n.curHistory);
    };

    // Custom comparator that compares the string objects by length
    static bool equalByHist(const VNode& n1, const VNode& n2) {
      return (n1.curHistory == n2.curHistory);
    };

    /**
     * @brief print a Viterbi State (and compute it
     * if not already done).
     **/
    friend std::ostream& operator<<(std::ostream& os, VNode& l);

    std::vector<VocId> curHistory;
    Utterance bestPath;
    double score;
    size_t maxHist;  ///< Maximum history to keep

   protected:
    double update_score(const std::vector<VocId>& contexte,
                        double previous,
                        const std::vector<VocId>& trans,
                        double transScore);

   private:
  };


 private:
};

/**
 *@brief Print "Hello world!".
 */
void print_hello();

/**
 * @brief Print a random integer between 0 and 100.
 */
void print_rnd_int();

}  // namespace viterbi

#endif /* End VITERBI_VITERBI_HPP guard */
