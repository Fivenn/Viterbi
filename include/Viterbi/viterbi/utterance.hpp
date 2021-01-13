/**
 * @file   utterance.hh
 * @Author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date   July, 2017
 * @brief  Utterance management
 */

#ifndef UTTERANCE_HH
#define UTTERANCE_HH

#include <cstdint>
#include <string>
#include <vector>

#include "viterbi/vocabulary.hpp"

namespace viterbi {

/**
 * @brief Class to manage utterances (the sentence to paraphrase).
 **/
class Utterance {
 public:
  /* Rule of 5 */
  Utterance() = delete;
  Utterance(Utterance const& other) = default;
  Utterance& operator=(Utterance const& other) = default;
  Utterance(Utterance&& other) = default;
  Utterance& operator=(Utterance&& other) = default;
  ~Utterance() = default;

  /* Construtors */
  Utterance(std::shared_ptr<Vocabulary>& v);
  Utterance(const std::string& text, std::shared_ptr<Vocabulary>& v);

  /**
   * @brief Add a work at the end of the utterance.
   **/
  void add_word(const std::string& w);

  /**
   * @brief Add a work at the end of the utterance.
   **/
  void add_word_id(const VocId& w);

  /**
   * @brief Get a work at the end of the utterance.
   **/
  VocId get_word_id(size_t pos) const;

  /**
   * @brief Clear the utterance.
   **/
  void clear();

  /**
   * @brief Return the number of words (or vocabulary or place that can be
   *modified) of the utterance.
   **/
  size_t size() const;

  /**
   * @brief allows to look at the data associated to the utterance
   **/
  inline const std::vector<VocId>& get_data() const { return data; };

  /**
   * @brief print an utterance
   **/
  friend std::ostream& operator<<(std::ostream& os, const Utterance& utt);

 protected:
  std::vector<VocId> data;
  std::shared_ptr<Vocabulary> voc;

 private:
};

}  // End Namespace viterbi
#endif
