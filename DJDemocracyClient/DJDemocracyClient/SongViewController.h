//
//  SongViewController.h
//  DJDemocracyClient
//
//  Created by Andrew Russell on 12/17/13.
//
//

#import <UIKit/UIKit.h>
#import "Server.h"

//@class Server;

@interface SongViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    Server *_server;
    NSMutableArray *_songs;
}

@property (nonatomic, retain) Server *server;

- (void) addSong:(NSString*) message;
- (IBAction)unwindToOverview:(UIStoryboardSegue *)segue;

//@property (strong, nonatomic) NSMutableArray *songs;



@end
