//
//  AppDelegate.m
//  DJDemocracyClient
//
//  Created by Andrew Russell on 12/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *type = @"TestingProtocol";
    _server = [[Server alloc] initWithProtocol:type];
    _server.delegate = self;
    //songViewController.server = _server;
    
    NSError *error = nil;
    if(![_server start:&error]) {
        NSLog(@"error: = %@", error);
    }
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                     bundle: nil];
    
    //navController = [[UINavigationController alloc] initWithRootViewController:[self.window rootViewController]];
    
    //serverViewController = (ServerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ServerView"];
        
    serverViewController = [[[self.window rootViewController] childViewControllers] objectAtIndex:0];
    overviewViewController = (OverviewViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"OverviewView"];

    
    navController = [[self.window rootViewController] navigationController];
    
    serverViewController.overviewViewController = overviewViewController;
    
    //serverViewController.server = _server;
    //serverViewController.navigationController = navController;
    
    
    //self.window.rootViewController = serverViewController;
    
    serverViewController.server = _server;
    
    
    //[window addSubview:[navigationController view]];
    //[window makeKeyAndVisible];
    
    NSLog(@"App Started");
    
    return YES;
}


#pragma mark Server Delegate Methods

- (void)serverRemoteConnectionComplete:(Server *)server {
    NSLog(@"Server Started");
    // this is called when the remote side finishes joining with the socket as
    // notification that the other side has made its connection with this side
    serverViewController.server = server;
    //[self.navigationController pushViewController:songViewController animated:YES];
}

- (void)serverStopped:(Server *)server {
    NSLog(@"Server stopped");
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
    NSLog(@"Server did accept data"); // %@", data);
    NSString *message = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if(nil != message || [message length] > 0) {
        //NSLog(@"%@", message);
        [overviewViewController addSong:message];
    } else {
        NSLog(@"%@", @"no data received");
    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
    NSLog(@"Server lost connection %@", errorDict);
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
    NSLog(@"Service received");
    //NSLog(@"%@ %d", service.name, more);
    
    [serverViewController addServer:service moreComing:more];
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
    [serverViewController removeServer:service moreComing:more];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
