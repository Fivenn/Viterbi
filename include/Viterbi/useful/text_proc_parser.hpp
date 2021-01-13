/**
 * @file text_proc_parser.hh
 * @author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date October, 2012
 * @brief Define parser interface and classes to parse text into tokens/terms.
 */

#ifndef USEFUL_TEXT_PROC_PARSER_HH
#define USEFUL_TEXT_PROC_PARSER_HH

/* Inclusion stdlib */
#include <algorithm>
#include <deque>
#include <list>
#include <map>
#include <vector>

/* ES et parser*/
#include <iomanip>
#include <iostream>

#include <sstream>
#include <string>

#include <cstdlib>

/* For Hash map */
#include <bitset>
#include <queue>
#include <unordered_map>

#include <functional>

namespace useful {
namespace text_processing {

/*****************************************************************************/
/**
 * @class IParser
 * @brief Parser interface
 *
 * An interface for all text parsers.
 * Parse a stream composed by documents and
 * documents are composed by terms.
 **/
class IParser {
 public:
  /**
   * @brief Destructor of IParser.
   **/
  virtual ~IParser(){};

  /**********************/
  /**
   * @class endParse
   * @brief Parser exception raised when end of stream is reached.
   **/
  class EndParse {
   public:
    /**
     * @brief Exception endParse constructor.
     * @param[in] r Pair with the last term and if it is from a new document.
     * @param[in] e Is r is empty ?
     **/
    EndParse(std::pair<bool, std::string> r, bool e);

    /**
     * @brief
     *  res.first : the last term come from a new document ;
     *  res.second : last term read.
     **/
    const std::pair<bool, std::string> res;
    const bool empty;  ///< Says if the last term is empty or not
  };

  /**********************/
  /**
   * @class emptyParse
   * @brief Class exception when the parsing returns an empty term.
   **/
  class EmptyParse {};

  /* Members */

  /**
   * @brief Get the next term parsed.
   * @throw emptyParse If the next term is empty.
   * @throw endParse If end of stream reached.
   * @return Pair with the next term and if it is from a new document.
   **/
  virtual std::pair<bool, std::string> get_term() = 0;
  /**
   * @brief Get the next document parsed.
   * @throw endParse If end of stream reached.
   * @return The next document.
   * @warning discard all terms from the previous documents.
   **/
  virtual std::string get_doc() = 0;

  /**
   * @brief Get the text of the last document read (may not be raw).
   * @return The text of the document read when the first element of the
   * result of a call to get_term() where true.
   **/
  virtual std::string get_current_doc() = 0;

  /**
   * @brief Get the header of the current document.
   * @return A header corresponding of the document read when the first
   *element of the result of a call to get_term() where true.
   **/
  virtual std::string get_current_header() = 0;

  /**
   * @brief Get the number of term read from the current document.
   * @return The atomic term read until now from the document read  when
   *the first element of the result of a call to get_term() where true.
   **/
  virtual int get_current_doc_nb_term() = 0;

  /**
   * @todo Deal with headers.
   **/
  virtual void apply_on_terms(std::function<void(std::string)> termF,
                              std::function<void(std::string)> docF,
                              std::function<void()> postDoc);

  /**
   * @todo Deal with headers.
   **/
  virtual void apply_on_docs(std::function<void(std::string)> docF);
};

/*****************************************************************************/
/**
 * @class parseToNgramWords
 * @brief A word parser returning ngram of terms of a document stream.
 *         Documents are separeted by a given character
 *         and terms by a list of characters.
 * @note A ngram is the concatenation of n successive terms
 * @warning This version is not compatible with utf-8.
 **/
class ParseToNgramWords : public IParser {
 public:
  /**
   * @brief Ngram parser constructor.
   * @param[in, out] s      stream where documents are parsed.
   * @param[in]      n      Size of ngrams returns by get_term().
   * @param[in]      w      List of characters considers as term separator.
   * @param[in]      d      Charater considers as document separator.
   * @param[in]      header Is the first term of each document is a header ?
   **/
  ParseToNgramWords(std::istream* s,
                    size_t n = 3,
                    std::string w = " ",
                    char d = '\n',
                    bool header = false);



  ParseToNgramWords() = delete;
  ParseToNgramWords(ParseToNgramWords const& other) = delete;
  ParseToNgramWords& operator=(ParseToNgramWords const& other) = delete;
  ParseToNgramWords(ParseToNgramWords&& other) = delete;
  ParseToNgramWords& operator=(ParseToNgramWords&& other) = delete;
  ~ParseToNgramWords() = default;

  /**
   * @sa IParser::get_term
   * @warning  Word separators between ngrams returned by get_term() are
   *            the same as the ones in current document. No normalisation.
   *            This mean that two ngram composed with the same terms may be
   *            seen as different if the separator is different.
   **/
  std::pair<bool, std::string> get_term();

  std::string get_doc();

  /* Information sur le document courant */
  std::string get_current_doc();
  std::string get_current_header();
  int get_current_doc_nb_term();

 protected:
  /**
   * @brief Reserved token to fill ngram at the begining and the end of a
   *document (default "**").
   **/
  const std::string borderToken;

  std::istream* ist;    ///< Documents are read from this input stream pointer.
  std::string wordSep;  ///< list of characters considers as term separator.

  /**
   * @brief Default term separator. Used by example to separate border tokens.
   * It is one of the wordSep list (often the first).
   **/
  std::string defaultWordSep;
  std::bitset<255> wordSepBS;  ///< Bitset for fast word separator recognition.

  size_t sizeNgram;  ///< Size of the ngram return by get_term().

  /**
   * @brief Buffer used to stack enough terms to produce a term of sizeNgram
   * size. It store iterators on currentDoc. This means that word separators
   * between ngrams returned by get_term() are the same as the ones in current
   * document.
   * @note No normalisation.
   **/
  std::deque<
      std::pair<std::string::const_iterator, std::string::const_iterator> >
      ngramBuffer;

  char docSep;             ///< Character considers as a document separator. */
  std::string currentDoc;  ///< The current document.
  int currentDocNbTerm;    ///< Number of term founded in the current document
                           /// so far.
  int nbDoc;               ///< Number of document parsed so far.

  std::string
      currentHeader;  ///< Header of the current document if any. Else, nbDoc.
  bool withHeader;    ///< Is the first term of each document is a header ?
 private:
  /**
   * @brief Modify the current document to add borderToken at the end and
   *begining. It is needed to produce ngram on document border.
   * @param[in,out] currentDoc The document to change.
   * @return number of borderToken added.
   **/
  int add_border_tokens(std::string& currentDoc);

  /**
   * @brief Iterator on the begining of the current term in the current
   * document
   **/
  std::string::iterator currentBegin;
  /**
   * @brief Position of the parsing process in the current document
   **/
  std::string::iterator currentIT;
  /**
   * @brief Element between currentBegin and currentIT are members of a term or
   *delimiters ?
   **/
  bool inToken;
};

/*****************************************************************************/
/**
 * @class parseToWords
 * @brief A word parser of a document stream.
 *         Documents are separeted by a given character
 *         and terms by a list of characters.
 * @note Use parseToNgramWords with n = 1
 * @warning This version is not fully compatible with utf-8.
 */
class ParseToWords : public ParseToNgramWords {
 public:
  ParseToWords(std::istream* s,
               std::string w = " ",
               char d = '\n',
               bool header = false);
};

}  // End namespace text_processing
}  // End namespace useful

#endif
