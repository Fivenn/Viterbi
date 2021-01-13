#include "useful/various.hpp"

/********************************************************************/
/* Logs    	      	     	     	     	     	    */
/********************************************************************/

/* config logger */
void useful::config_logger(bool verbose, bool quiet) {
  //  el::Loggers::reconfigureAllLoggers(el::ConfigurationType::Filename,
  //             "logs/project.log");

  // Default datetime : "%datetime{%y-%M-%d %H:%m:%s,%g}"
  // Short datetime : "%H:%m:%s,%g"
  /*  el::Loggers::reconfigureAllLoggers(
        el::ConfigurationType::Format,
        "[%datetime{%H:%m:%s}] %level  [%func in %fbase:%line] : %msg");*/
  el::Loggers::addFlag(el::LoggingFlag::ColoredTerminalOutput);

  el::Loggers::reconfigureAllLoggers(
      el::ConfigurationType::Format,
      "[%datetime{%H:%m:%s}] %level [%fbase:%line] %msg");
  el::Loggers::reconfigureAllLoggers(el::Level::Info,
                                     el::ConfigurationType::Format,
                                     "[%datetime{%H:%m:%s}] %level %msg");
  /*
  el::Loggers::reconfigureAllLoggers(el::Level::Trace,
                                     el::ConfigurationType::Format,
                                     "[%datetime{%H:%m:%s}] %level
  [%fbase:%line] %msg");
  el::Loggers::reconfigureAllLoggers(el::Level::Debug,
                                     el::ConfigurationType::Format,
                                     "[%datetime{%H:%m:%s}] %level [%func]
                                      [%fbase:%line] %msg");
   */
#ifdef ELPP_DISABLE_DEBUG_LOGS
  if (verbose) {
    LOG(WARNING) << "Ask for debug logs but Cmake was not compile with "
                    "debug on. All debugs stay hidden.";
  }
#endif
#ifdef ELPP_DISABLE_TRACE_LOGS
  if (verbose) {
    LOG(WARNING) << "Ask for trace logs but Cmake was not compile with "
                    "debug on. All traces stay hidden.";
  }
#endif
  if (quiet && verbose) {
    LOG(WARNING)
        << "Ask for verbose and quiet. Quiet mode will be used from now";
    verbose = false;
  }

  if (quiet) {
    el::Loggers::reconfigureAllLoggers(el::Level::Info,
                                       el::ConfigurationType::Enabled, "false");
    el::Loggers::reconfigureAllLoggers(el::Level::Warning,
                                       el::ConfigurationType::Enabled, "false");
  }
  if (!verbose) {
    el::Loggers::reconfigureAllLoggers(el::Level::Debug,
                                       el::ConfigurationType::Enabled, "false");
    el::Loggers::reconfigureAllLoggers(el::Level::Trace,
                                       el::ConfigurationType::Enabled, "false");
  }
}
