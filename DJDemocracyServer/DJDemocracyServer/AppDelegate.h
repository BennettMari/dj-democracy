//
//  AppDelegate.h
//  DJDemocracyServer
//
//  Created by Mauricio Molina on 12/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import <EyeTunes/EyeTunes.h>
#import "DJTrack.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ServerDelegate> {
    IBOutlet NSTableView *playlistTable;
    IBOutlet NSTableView *deviceTable;
    IBOutlet NSTableView *songTable;
    //ETTrack *inoutTrack;
    NSMutableArray *_playlist;
    NSWindow *window;
    Server *_server;
    NSMutableArray *_playlists;
    NSMutableArray *_services;
    NSString *textToSend, *_message;
	NSInteger selectedPlaylist, selectedRow, connectedRow;
	BOOL isConnectedToService;
    BOOL showingSongs;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) Server *server;
@property (nonatomic, retain) NSArray *playlists;
@property (nonatomic, retain) NSMutableArray *services;
@property(readwrite, copy) NSString *message;
@property(readwrite, retain) NSMutableArray *playlist;
@property(readwrite, nonatomic) BOOL isConnectedToService;



- (IBAction)connectToService:(id)sender;
- (IBAction)sendSongs:(id)sender;
- (IBAction)startServer:(id)sender;

NSInteger voteSort(id num1, id num2, void *context);


@end
