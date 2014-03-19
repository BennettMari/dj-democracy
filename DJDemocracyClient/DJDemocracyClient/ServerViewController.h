//
//  ViewController.h
//  DJDemocracyClient
//
//  Created by Andrew Russell on 12/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface ServerViewController : UITableViewController {
    Server *_server;
    NSMutableArray *_services;
    //UIViewController *overviewViewController;
}

@property (nonatomic, retain) Server *server;
@property (nonatomic, retain) UIViewController *overviewViewController;

- (void)addServer:(NSNetService *)service moreComing:(BOOL)moreComing;
- (void)removeServer:(NSNetService *)service moreComing:(BOOL)moreComing;
- (IBAction)unwindToServers:(UIStoryboardSegue *)segue;
- (NSMutableArray *) services;

@end