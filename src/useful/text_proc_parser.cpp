/**
 * @file text_processing_parser.cpp
 * @author J. Chevelu (jonathan.chevelu@irisa.fr)
 * @date October, 2012
 * @brief Define parser interface and classes to parse text into tokens/terms.
 */

#include "useful/text_proc_parser.hpp"
#include "useful/various.hpp"  //For logs

using namespace std;
using namespace useful::text_processing;

/*****************************************/
/* IParser                               */

IParser::EndParse::EndParse(std::pair<bool, std::string> r, bool e)
    : res(r), empty(e) {}

void IParser::apply_on_terms(std::function<void(std::string)> termF,
                             std::function<void(std::string)> docF,
                             std::function<void()> postDoc) {
  try {
    while (true) {
      try {
        auto r = get_term();
        if (r.first) {
          postDoc();
          docF(get_current_doc());
        }
        termF(r.second);
      } catch (IParser::EmptyParse e) { /* Term vide: nothing to do */
      }
    }
  } catch (IParser::EndParse e) {
    if (!e.empty) {
      if (!e.res.first) {
        // One last term in the previous doc
        termF(e.res.second);
      } else {
        // One last term in a new doc
        postDoc();
        docF(get_current_doc());
        termF(e.res.second);
      }
    }
    postDoc();
  }
}

void IParser::apply_on_docs(std::function<void(std::string)> docF) {
  try {
    while (true) {
      docF(get_doc());
    }
  } catch (IParser::EndParse e) {
    if (!e.empty && e.res.first) {
      // One last term in a new doc
      docF(get_doc());
    }
  }
}

/*****************************************/
/* parseToNgramWords members             */

ParseToNgramWords::ParseToNgramWords(istream* s,
                                     size_t n,
                                     std::string w,
                                     char d,
                                     bool header)
    : borderToken("**") {
  sizeNgram = n;
  ist = s;
  docSep = d;
  wordSep = w;
  defaultWordSep = wordSep.c_str()[0];
  currentDoc = "";
  currentIT = currentDoc.end();
  currentHeader = "";
  nbDoc = 0;
  withHeader = header;
  const char* ws = wordSep.c_str();
  while (*ws) {
    unsigned char code = static_cast<unsigned char>(*ws++);
    wordSepBS[code] = true;
  }
}

int ParseToNgramWords::add_border_tokens(string& currentDoc) {
  int nbTermAdded = 0;

  /* Add empty tokens for border management */
  if (sizeNgram > 1) {
    string borderBegin;
    borderBegin.reserve(currentDoc.length() + 8 * sizeNgram);
    borderBegin.append(borderToken);
    nbTermAdded += 2;
    for (unsigned i = 0; i < sizeNgram - 2; i++) {
      borderBegin.append(defaultWordSep).append(borderToken);
      nbTermAdded += 2;
    }
    string borderEnd(borderBegin);

    borderBegin.append(defaultWordSep)
        .append(currentDoc)
        .append(defaultWordSep)
        .append(borderEnd);
    borderBegin.swap(currentDoc);
  }

  return nbTermAdded;
}

std::string ParseToNgramWords::get_doc() {
  currentDoc = "";
  currentHeader = "";
  currentDocNbTerm = 0;

  /* load new doc for processing */
  while (currentDoc.length() == 0 && !ist->eof()) {
    /* Loading from stream */
    getline(*ist, currentDoc, docSep);

    /* Init current doc */
    inToken = false;
    currentIT = currentDoc.begin();
    nbDoc++;

    /* header init */
    if (!withHeader) {
      stringstream ss;
      ss << nbDoc;
      currentHeader = ss.str();
      currentDocNbTerm -= add_border_tokens(currentDoc);
    }
  }

  if (ist->eof() && currentDoc.empty()) {
    ist->clear();
    EndParse e(pair<bool, std::string>(false, ""), false);
    throw e;
  }

  return currentDoc;
}

/* Note : not compatible with utf8 */
pair<bool, std::string> ParseToNgramWords::get_term() {
  bool newDoc = false;
  std::string nextTerm = "";

  /* Last doc was proccessed, need new doc */
  if (ngramBuffer.empty() && currentIT == currentDoc.end()) {
    LOG(DEBUG) << "Need to load a new doc";
    currentDoc = "";
    currentHeader = "";
    currentDocNbTerm = 0;

    /* load new doc for processing */
    while (currentDoc.length() == 0 && !ist->eof()) {
      /* Loading from stream */
      getline(*ist, currentDoc, docSep);
      // LOG(DEBUG) << "Current doc : \"" << currentDoc << "\"";

      // LOG(DEBUG) << "CurrentIT : \"" << *currentIT << "\"";
      nbDoc++;
      newDoc = true;

      /* header init */  // TODO: Test/DEBUG
      if (!withHeader) {
        stringstream ss;
        ss << nbDoc;
        currentHeader = ss.str();
        currentDocNbTerm -= add_border_tokens(currentDoc);
        // Warning: current doc might be moved so currentIt must be reset.
      }

      /* Init current doc */
      inToken = false;
      currentIT = currentDoc.begin();
    }
  }

  /* Fill the buffer with enough words */
  while (currentIT != currentDoc.end()) {
    // Working only with ascii
    if ((*currentIT >= 0) /*&& (*currentIT < 255)*/ &&
        (wordSepBS[static_cast<size_t>(*currentIT)])) {  // We found a separator
      // LOG(DEBUG) << "Separator found";

      // If multiple separator with nothing inside: skip it.
      if (inToken) {
        inToken = false;
        if (currentHeader.empty()) {
          // LOG(TRACE) << "Work on header";
          currentHeader = string(currentBegin, currentIT);
          currentDoc.erase(currentDoc.begin(), currentIT);
          currentDocNbTerm -= add_border_tokens(currentDoc);
          currentIT = currentDoc.begin();
          continue;  // Do not incr currentIT !
        } else {
          ++currentDocNbTerm;
          ngramBuffer.push_back(make_pair(currentBegin, currentIT));
          if (ngramBuffer.size() >= sizeNgram) {
            break;
          }
        }
      }
    } else if (!inToken) {
      currentBegin = currentIT;
      inToken = true;
    }
    ++currentIT;
  }

  /* Last token management */
  if (currentIT == currentDoc.end() && inToken) {
    if (currentHeader.empty() && withHeader) {
      currentHeader = string(currentBegin, currentIT);
      currentDoc.erase(currentDoc.begin(), currentIT);
      currentDocNbTerm -= add_border_tokens(currentDoc);
      currentIT = currentDoc.begin();
    } else {
      ++currentDocNbTerm;
      ngramBuffer.push_back(make_pair(currentBegin, currentIT));
    }
    inToken = false;
  }

  /* Produce term */
  if (ngramBuffer.size() == sizeNgram) {
    nextTerm.reserve(currentDoc.size());
    auto it = ngramBuffer.begin();
    if (it != ngramBuffer.end()) {
      nextTerm.append(it->first, it->second);
      it++;
    }
    while (it != ngramBuffer.end()) {
      nextTerm.append(defaultWordSep).append(it->first, it->second);
      it++;
    }

    ngramBuffer.pop_front();

  } else {  // must be end of doc
    ngramBuffer.clear();
  }

  nextTerm.shrink_to_fit();

  /* End stream processing  */
  if ((currentIT == currentDoc.end()) && ngramBuffer.empty() && ist->eof()) {
    ist->clear();
    EndParse e(pair<bool, std::string>(newDoc, nextTerm),
               nextTerm.length() == 0);
    throw e;
  }

  /* Case with empty term but not empty document (should not be possible)) */
  if (nextTerm.length() == 0) {
    EmptyParse e;
    throw e;
  }

  return pair<bool, std::string>(newDoc, nextTerm);
  /* End of stream, nextTerm is empty */
}

string ParseToNgramWords::get_current_doc() {
  return currentDoc;
}
string ParseToNgramWords::get_current_header() {
  return currentHeader;
}
int ParseToNgramWords::get_current_doc_nb_term() {
  return currentDocNbTerm;
}

/*****************************************/
/* ParseToWords */

ParseToWords::ParseToWords(std::istream* s, std::string w, char d, bool header)
    : ParseToNgramWords(s, 1, w, d, header){};
