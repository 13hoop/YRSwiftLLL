//
//  BluetoothLEManager.m
//  SensorApp
//
//  Created by Scott Gruby on 12/12/12.
//  Copyright (c) 2012 Scott Gruby. All rights reserved.
//

#import "BluetoothLEManager.h"

@interface BluetoothLEManager () <CBCentralManagerDelegate>
@property (nonatomic, weak) id<BluetoothLEManagerDelegateProtocol> delegate;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, assign) BOOL pendingInit;
@property (nonatomic, strong) NSMutableArray *foundPeripherals;
@property (nonatomic, copy) NSString *deviceName;
@end

@implementation BluetoothLEManager

+ (BluetoothLEManager *) sharedManager
{
    return [self sharedManagerWithDelegate:nil];
}

+ (BluetoothLEManager *) sharedManagerWithDelegate:(id<BluetoothLEManagerDelegateProtocol>)delegate
{
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] initWithDelegate:delegate];
    });
    return sharedManager;
}

- (id) initWithDelegate:(id<BluetoothLEManagerDelegateProtocol>) delegate
{
    self = [super init];
    if (self)
    {
        self.pendingInit = YES;
        self.delegate = delegate;
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
        self.foundPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Restoring
/****************************************************************************/
/*								Settings									*/
/****************************************************************************/
/* Reload from file. */
- (void) loadSavedDevices
{
    NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    
    if (![storedDevices isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    NSMutableArray *uuidArray = [[NSMutableArray alloc] init];
    
    for (id deviceUUIDString in storedDevices)
    {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
        {
            continue;
        }
        
        //B150108001 Andy for iOS8
        //        CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
        NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:deviceUUIDString];
        if (!uuid)
        {
            continue;
        }
        
        //B150108001 Andy
        //		if (![uuidArray containsObject:(__bridge id)uuid])
        //		{
        //			[uuidArray addObject:(__bridge id)uuid];
        //		}
        //        CFRelease(uuid);
        if (![uuidArray containsObject:uuid]) {
            [uuidArray addObject:uuid];
        }
    }
    
    if ([uuidArray count])
    {
        //B150108001 Andy
        //        [self.centralManager retrievePeripherals:uuidArray];
        [self.centralManager retrievePeripheralsWithIdentifiers:uuidArray];
    }
    
}

// If we connect a device with the service we want, add it to our device list
// so that we can automatically restore it later.
- (void) addSavedDevice:(CFUUIDRef) uuid
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    CFStringRef		uuidString		= NULL;
    
    if (![storedDevices isKindOfClass:[NSArray class]] && storedDevices != nil)
    {
        return;
    }
    
    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString)
    {
        if (![newDevices containsObject:(__bridge NSString*)uuidString])
        {
            [newDevices addObject:(__bridge NSString*)uuidString];
        }
        CFRelease(uuidString);
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// If we explicitly disconnect a device, remove it from our device list
- (void) removeSavedDevice:(CFUUIDRef) uuid
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    CFStringRef		uuidString		= NULL;
    
    if ([storedDevices isKindOfClass:[NSArray class]])
    {
        newDevices = [NSMutableArray arrayWithArray:storedDevices];
        
        uuidString = CFUUIDCreateString(NULL, uuid);
        if (uuidString)
        {
            [newDevices removeObject:(__bridge NSString*)uuidString];
            CFRelease(uuidString);
        }
        /* Store */
        [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// Callback from retrieveConnectedPeripherals
- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    /* Add to list. */
    for (CBPeripheral *peripheral in peripherals)
    {
        if (peripheral.state == CBPeripheralStateConnected)
        {
            // Basically retain the peripheral
            if (![self.foundPeripherals containsObject:peripheral])
            {
                [self.foundPeripherals addObject:peripheral];
            }
            
            [self connectPeripheral:peripheral];
        }
    }
    
    // After we get all the connected devices, get the devices that
    // we stored before
    [self loadSavedDevices];
    
    // Nuke the list to clear out any devices that are no longer around.
    // This will be rebuilt when devices are connected
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Callback from retrievePeripherals
- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    for (CBPeripheral *peripheral in peripherals)
    {
        if (![self.foundPeripherals containsObject:peripheral])
        {
            [self.foundPeripherals addObject:peripheral];
        }
        
        if (peripheral.state != CBPeripheralStateConnected)
        {
            [self connectPeripheral:peripheral];
        }
    }
}

#pragma mark - Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
// This assume that the name is advertised
- (void) discoverDevices
{
    if (self.delegate == nil)
    {
        return;
    }
    NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}


- (void) stopScanning
{
    [self.centralManager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.foundPeripherals containsObject:peripheral])
    {
        [self.foundPeripherals addObject:peripheral];
    }
    
    [self.delegate didDiscoverPeripheral:peripheral advertisementData:advertisementData];
}

#pragma mark - Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral *) peripheral
{
    if (peripheral.state != CBPeripheralStateConnected)
    {
        //A140816001 Andy - 限制 Device Name
        //Simple BLE Peripher
        //if ([peripheral.name isEqualToString:@"P!NK"]){
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
        //} else {
        //    [self.delegate didConnectPeripheral:peripheral error:nil];
        //}
    }
    else
    {
        [self.delegate didConnectPeripheral:peripheral error:nil];
    }
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    //B150108001 Andy
    //	[self removeSavedDevice:peripheral.UUID]; // Only remove if we explictly disconnected
    [self removeSavedDevice:(__bridge CFUUIDRef)(peripheral.identifier)];
    [self.centralManager cancelPeripheralConnection:peripheral];
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (![self.foundPeripherals containsObject:peripheral])
    {
        [self.foundPeripherals addObject:peripheral];
    }
    
    //B150108001 Andy
    //    [self addSavedDevice:peripheral.UUID];
    [self addSavedDevice:(__bridge CFUUIDRef)(peripheral.identifier)];
    [self.delegate didConnectPeripheral:peripheral error:nil];
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.delegate didConnectPeripheral:peripheral error:error];
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.delegate didDisconnectPeripheral:peripheral error:error];
}

- (void) clearDevices
{
    [self.foundPeripherals removeAllObjects];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
    switch ([self.centralManager state])
    {
        case CBCentralManagerStatePoweredOff:
        {
            [self clearDevices];
            break;
        }
            
        case CBCentralManagerStateUnauthorized:
        {
            /* Tell user the app is not allowed. */
            break;
        }
            
        case CBCentralManagerStateUnknown:
        {
            /* Bad news, let's wait for another event. */
            break;
        }
            
        case CBCentralManagerStateUnsupported:
        {
            break;
        }
            
        case CBCentralManagerStatePoweredOn:
        {
            self.pendingInit = NO;
            //B150108001 Andy
            //			[self.centralManager retrieveConnectedPeripherals];
            [self.centralManager retrieveConnectedPeripheralsWithServices:self.foundPeripherals];
            break;
            
        }
            
        case CBCentralManagerStateResetting:
        {
            [self clearDevices];
            self.pendingInit = YES;
            break;
        }
    }
    
    previousState = [self.centralManager state];
    [self.delegate didChangeState:previousState];
}

@end
