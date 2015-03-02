//
//  LoggerMacro.h
//  ModSpot
//
//  Created by Enlan Zhou on 1/20/15.
//  Copyright (c) 2015 Earmarc, INC. All rights reserved.
//

/*
 Example:
 if ENLOGGING_LEVEL_DEBUG is 1, which means turns on, then:
 ENDebug(@"lala %@", @"haha"); //string with format, follow with argument(s)
 will print on console:
 [DEBUG] lala haha
 
 ENDebug(@"hahaha"); //plain string
 will print on console:
 [DEBUG] hahaha
 
 same to the ENError and ENInfo
 ENError(@"%@",error.description);
 */

#ifndef ModSpot_LoggerMacro_h
#define ModSpot_LoggerMacro_h

/*
 * There are three levels of logging: debug, info and error, and each can be enabled independently
 * via the ENLOGGING_LEVEL_DEBUG, ENLOGGING_LEVEL_INFO, and ENLOGGING_LEVEL_ERROR switches below, respectively.
 * In addition, ALL logging can be enabled or disabled via the ENLOGGING_ENABLED switch below.
 *
 * To perform logging, use any of the following function calls in your code:
 *
 * ENDebug(fmt, …) – will print if ENLOGGING_LEVEL_DEBUG is set on.
 * ENInfo(fmt, …) – will print if ENLOGGING_LEVEL_INFO is set on.
 * ENHeading(fmt, …) – will print if ENLOGGING_LEVEL_INFO is set on.
 * ENError(fmt, …) – will print if ENLOGGING_LEVEL_ERROR is set on.
 *
 * Each logging entry can optionally automatically include class, method and line information by
 * enabling the ENLOGGING_INCLUDE_CODE_LOCATION switch.
 *
 * Logging functions are implemented here via macros, so disabling logging, either entirely,
 * or at a specific level, removes the corresponding log invocations from the compiled code,
 * thus completely eliminating both the memory and CPU overhead that the logging calls would add.
 */

#define ENLOGGING_ENABLED 1

// Set any or all of these switches to enable or disable logging at specific levels.

#define ENLOGGING_LEVEL_DEBUG 1
#define ENLOGGING_LEVEL_INFO 1
#define ENLOGGING_LEVEL_ERROR 1

// Set this switch to set whether or not to include class, method and line information in the log entries.
#define ENLOGGING_INCLUDE_CODE_LOCATION 0

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Implementation
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if !(defined(ENLOGGING_ENABLED) && ENLOGGING_ENABLED)
#undef ENLOGGING_LEVEL_DEBUG
#undef ENLOGGING_LEVEL_INFO
#undef ENLOGGING_LEVEL_ERROR
#endif

// Logging format
#define ENLOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define ENLOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s [Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(ENLOGGING_INCLUDE_CODE_LOCATION) && ENLOGGING_INCLUDE_CODE_LOCATION
#define ENLOG_FORMAT(fmt, lvl, ...) ENLOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define ENLOG_FORMAT(fmt, lvl, ...) ENLOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Debug level logging

#if defined(ENLOGGING_LEVEL_DEBUG) && ENLOGGING_LEVEL_DEBUG
#define ENDebug(fmt, ...) ENLOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
#else
#define ENDebug(...)
#endif

// Info level logging

#if defined(ENLOGGING_LEVEL_INFO) && ENLOGGING_LEVEL_INFO
#define ENInfo(fmt, ...) ENLOG_FORMAT(fmt, @"INFO", ##__VA_ARGS__)
#define ENHeading(fmt, ...) ENLOG_FORMAT(@"####################  " fmt "  ####################", @"HD", ##__VA_ARGS__)
#else
#define ENInfo(...)
#define ENHeading(...)
#endif

// Error level logging

#if defined(ENLOGGING_LEVEL_ERROR) && ENLOGGING_LEVEL_ERROR
#define ENError(fmt, ...) ENLOG_FORMAT(fmt, @"**ERROR**", ##__VA_ARGS__)
#else
#define ENError(...)
#endif

#if defined(ENLOGGING_LEVEL_ERROR) && ENLOGGING_LEVEL_ERROR
#define ENResult(result, error) if (result == NO) ENError("%@", error)
#else
#define ENResult(...)
#endif

#endif
