#import "NXWWifiWizard.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

@interface NXWWifiWizard() {
    NSInteger m_loggingCounter;
}
@end

@implementation NXWWifiWizard

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (id)fetchSSIDInfo {
    m_loggingCounter++;
    // see http://stackoverflow.com/a/5198968/907720
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if(m_loggingCounter % 10 == 0) {
        NSLog(@"Supported interfaces: %@", ifs);
    }
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if(m_loggingCounter % 10 == 0) {
            NSLog(@"%@ => %@", ifnam, info);
        }
        if (info && [info count]) { break; }
    }
    return info;
}

- (void)addNetwork:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)removeNetwork:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)connectNetwork:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)disconnectNetwork:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)listNetworks:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)getScanResults:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)startScan:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)disconnect:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)getConnectedSSID:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    NSDictionary *r = [self fetchSSIDInfo];

    NSString *ssid = [r objectForKey:(id)kCNNetworkInfoKeySSID]; //@"SSID"
    NSString *ip = [self getIPAddress];

    if (ssid && [ssid length]) {
        NSDictionary* resultDict = @{
                                     @"SSID": ssid,
                                     @"IP": ip,
                                     };
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not available"];
    }

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)getConnectedBSSID:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult = nil;
        NSDictionary *r = [self fetchSSIDInfo];
        
        NSString *bssid = [r objectForKey:(id)kCNNetworkInfoKeyBSSID]; //@"SSID"
        
        if (bssid && [bssid length]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:bssid];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not available"];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    }];
}
- (void)isWifiEnabled:(CDVInvokedUrlCommand*)command {
    
}

- (void)setWifiEnabled:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not supported"];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

@end
