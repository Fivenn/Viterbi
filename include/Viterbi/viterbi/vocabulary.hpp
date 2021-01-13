/**
 * @file   vocabulary.hh
 * @Author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date   December, 2015
 * @brief  vocabulary management
 */

#ifndef VOCABULARY_HH
#define VOCABULARY_HH

#include <algorithm>
#include <cstdint>
#include <functional>  // std::greater
#include <iostream>
#include <iterator>
#include <memory>  // shared pointers
#include <queue>   // std::priority_queue
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace viterbi {

/**
 * @brief Index associated to a string (must be positive).
 * @note Index are positives values. Negatives values are used for special
 *vocabularies.
 **/
typedef std::int64_t VocId;

/**
 * @brief String management
 * @TODO Memory shared version of it.
 **/
class Vocabulary {
 public:
  /**
   * @brief Insert an item in the vocabulary.
   * @param[in] elem The element to add.
   * @pram[in] nocheck Do not check if the element is already present.
   * @return The vocId of the element
   **/
  VocId add_voc(const std::string& elem, bool nocheck = false);

  /**
   * @brief Convert a tokenized phrase into a sequence of vocId
   * @param[in] phrase The tokenized phrase to convert
   * @note missing vocabulary are added. Use space as delimiter
   **/
  std::vector<VocId> add_utterance(const std::string& utt);

  /**
   * @brief return the vocId of a string. It must be present
   * @param[in] elem The elem to search
   * @return the VocId of the element
   **/
  inline VocId get_vocId(const std::string& elem);

  /**
   * @warning VocId must be a valid Id. Else error
   **/
  inline const std::string& get_voc(VocId id);

  /**
   * @brief get the string associated to an array of vocIds.
   **/
  std::string to_utterance(std::vector<VocId> va, const std::string& sep = " ");

  /*
   * Special vocabulary values
   */
  static const VocId UNK = -1;          ///< Unknow element
  static const std::string UNK_STR;     ///< Unknow element
  static const VocId ANY = -2;          ///< Wildcard element (anything)
  static const std::string ANY_STR;     ///< Wildcard element (anything)
  static const VocId EMPTY = -3;        ///< Empty element
  static const std::string EMPTY_STR;   ///< Empty element
  static const VocId FILLER = -4;       ///< Filler element
  static const std::string FILLER_STR;  ///< Filler element

  /**
   * Tests for reserved ids
   **/
  static bool is_unk(VocId id);
  static bool is_any(VocId id);
  static bool is_empty(VocId id);
  static bool is_filler(VocId id);

 protected:
  std::vector<std::string> vocArray;  ///< Vocabulary array
  std::unordered_map<std::string, VocId>
      strToArrayId;  ///< Map to get the VocId from a string

 private:
};

}  // End Namespace viterbi
#endif
