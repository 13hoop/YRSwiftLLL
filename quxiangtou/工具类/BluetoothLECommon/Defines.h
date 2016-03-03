//
//  Defines.h
//  SensorApp
//
//  Created by Scott Gruby on 12/19/12.
//  Copyright (c) 2012 Scott Gruby. All rights reserved.
//

#ifndef SensorApp_Defines_h
#define SensorApp_Defines_h

#ifdef INFO_PLIST
#define STRINGIFY(_x)        _x
#else
#define STRINGIFY(_x)      # _x
#endif

#define STRX(x)			x

#define APP_VERSION_NUMBER				STRINGIFY(1.0.0)
#define CF_BUNDLE_VERSION				STRINGIFY(1)


#endif

#define kAutomaticalllyReconnect		@"Automatically Reconnect"
