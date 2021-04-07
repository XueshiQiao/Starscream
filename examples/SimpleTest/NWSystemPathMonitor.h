//
//  NWSystemPathMonitor.h
//  SimpleTest
//
//  Created by joey on 2021/4/4.
//  Copyright © 2021 vluxe. All rights reserved.
//

#ifndef NWSystemPathMonitor_h
#define NWSystemPathMonitor_h
@import Foundation;
@import Network;

@protocol OS_dispatch_source;
@class NWMonitor, NWPathEvaluator, BKSApplicationStateMonitor, NSMutableDictionary, NSObject;

@interface NWSystemPathMonitor : NSObject {

//    BOOL _wifiPrimary;
//    BOOL _ethernetPrimary;
//    BOOL _vpnActive;
//    int _vpnNotifyToken;
//    NWMonitor* _vpnMonitor;
//    NWPathEvaluator* _primaryEvaluator;
//    BKSApplicationStateMonitor* _applicationMonitor;
//    NSMutableDictionary* _perAppVPNEvaluators;
//    NSObject*<OS_dispatch_source> _smoothingTimer;
//    void* _fallbackWatcher;
//    NSObject*<OS_dispatch_source> _mptcpWatcher;

}

//@property (retain) NWMonitor * vpnMonitor;                                               //@synthesize vpnMonitor=_vpnMonitor - In the implementation block
//@property (retain) NWPathEvaluator * primaryEvaluator;                                   //@synthesize primaryEvaluator=_primaryEvaluator - In the implementation block
//@property (assign) int vpnNotifyToken;                                                   //@synthesize vpnNotifyToken=_vpnNotifyToken - In the implementation block
//@property (retain) BKSApplicationStateMonitor * applicationMonitor;                      //@synthesize applicationMonitor=_applicationMonitor - In the implementation block
//@property (retain) NSMutableDictionary * perAppVPNEvaluators;                            //@synthesize perAppVPNEvaluators=_perAppVPNEvaluators - In the implementation block
//@property (retain) NSObject<OS_dispatch_source> *smoothingTimer;                         //@synthesize smoothingTimer=_smoothingTimer - In the implementation block
@property (assign) void* fallbackWatcher;                                                //@synthesize fallbackWatcher=_fallbackWatcher - In the implementation block
@property (strong) id mptcpWatcher;                           //@synthesize mptcpWatcher=_mptcpWatcher - In the implementation block
@property (assign,getter=isVPNActive,nonatomic) BOOL vpnActive;                          //@synthesize vpnActive=_vpnActive - In the implementation block
@property (assign,getter=isWiFiPrimary,nonatomic) BOOL wifiPrimary;                      //@synthesize wifiPrimary=_wifiPrimary - In the implementation block
@property (assign,getter=isEthernetPrimary,nonatomic) BOOL ethernetPrimary;              //@synthesize ethernetPrimary=_ethernetPrimary - In the implementation block
+(instancetype)sharedSystemPathMonitor;
-(id)init;
//-(void)setPrimaryEvaluator:(NWPathEvaluator *)arg1 ;
//-(void)setMptcpWatcher:(NSObject*<OS_dispatch_source>)arg1 ;
//-(BOOL)isVPNActive;
//-(void)setWifiPrimary:(BOOL)arg1 ;
//-(NSObject*<OS_dispatch_source>)smoothingTimer;
//-(void)setSmoothingTimer:(NSObject*<OS_dispatch_source>)arg1 ;
//-(NSMutableDictionary *)perAppVPNEvaluators;
-(id)mptcpWatcher;
-(BOOL)isWiFiPrimary;
//-(void)setFallbackWatcher:(void*)arg1 ;
//-(void)setPerAppVPNEvaluators:(NSMutableDictionary *)arg1 ;
//-(NWPathEvaluator *)primaryEvaluator;
//-(void)setVpnMonitor:(NWMonitor *)arg1 ;
//-(void)stopWatchingApplicationStates;
//-(void)setVpnActive:(BOOL)arg1 ;
//-(void)updateFlags;
//-(void)setApplicationMonitor:(BKSApplicationStateMonitor *)arg1 ;
//-(int)vpnNotifyToken;
-(void*)fallbackWatcher;
//-(void)registerForVPNNotifications;
//-(void)eventFired;
//-(void)setVpnNotifyToken:(int)arg1 ;
//-(BOOL)isEthernetPrimary;
//-(void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void*)arg4 ;
//-(void)dealloc;
//-(BKSApplicationStateMonitor *)applicationMonitor;
//-(void)updateVPNMonitor;
//-(void)appStateChangedWithUserInfo:(id)arg1 ;
//-(NWMonitor *)vpnMonitor;
//-(void)setEthernetPrimary:(BOOL)arg1 ;
//-(void)startWatchingApplicationStates;
@end


#endif /* NWSystemPathMonitor_h */
