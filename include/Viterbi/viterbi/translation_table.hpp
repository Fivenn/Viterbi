
#ifndef VITERBI_TRANSLATION_TABLE_HH
#define VITERBI_TRANSLATION_TABLE_HH

#include <map>
#include <memory>
#include <string>

#include "viterbi/vocabulary.hpp"

namespace viterbi {

class TRule {
 public:
  TRule() = default;
  TRule(TRule const& other) = default;
  TRule& operator=(TRule const& other) = default;
  TRule(TRule&& other) = default;
  TRule& operator=(TRule&& other) = default;
  ~TRule() = default;

  double cost;
  std::vector<VocId> source;
  std::vector<VocId> translation;
  std::shared_ptr<Vocabulary> voc;

  /**
   * @ brief print a translation rule
   **/
  friend std::ostream& operator<<(std::ostream& os, const TRule& p);

 protected:
 private:
};

class TranslationTable {
 public:
  TranslationTable() = delete;
  TranslationTable(std::shared_ptr<Vocabulary>& voc);
  TranslationTable(TranslationTable const& other) = default;
  TranslationTable& operator=(TranslationTable const& other) = default;
  TranslationTable(TranslationTable&& other) = default;
  TranslationTable& operator=(TranslationTable&& other) = default;
  ~TranslationTable() = default;

  void load(const std::string& filename);

  std::vector<TRule> get_rules(const std::vector<VocId>& search);


  friend std::ostream& operator<<(std::ostream& os, const TranslationTable& tt);

 protected:
  /**
   * Build for line
   * @note format : PHRASE ||| Translation ||| s1 s2 s3 s4
   **/
  void load_line(std::string& line);

  std::multimap<std::vector<VocId>, TRule> tPhrases;  // TODO: use a set
  std::shared_ptr<Vocabulary> voc;

  static const std::string MOSES_DELIM;
  static const std::string MOSES_FEATURE_DELIM;

 private:
};

}  // End Namespace viterbi
#endif
