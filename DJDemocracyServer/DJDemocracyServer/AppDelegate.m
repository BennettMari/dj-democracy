//
//  AppDelegate.m
//  DJDemocracyServer
//
//  Created by Mauricio Molina on 12/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.message = @"Message";
	connectedRow = -1;
	self.services = [[NSMutableArray alloc] init];
    self.playlist = [[NSMutableArray alloc] init];
	
	/*NSString *type = @"TestingProtocol";
    
	_server = [[Server alloc] initWithProtocol:type];
    _server.delegate = self;
    
    NSError *error = nil;
    if(![_server start:&error]) {
        NSLog(@"error = %@", error);
    }*/
    
    [self showPlaylists];
    
    
}

// Uses EyeTunes to get iTunes' playlists
- (void)showPlaylists; {
    EyeTunes *eyetunes = [EyeTunes sharedInstance];
    
    self.playlists = [[NSMutableArray alloc] init];
    self.playlists = [eyetunes userPlaylists];
    if (!self.playlists)
        return;
    
    //NSLog(self.playlists);
    
    /*NSLog(@"List of playlists:");
    for (id playlist in self.playlists) {
        //[self.playlists addObject:playlist];
        NSLog(@"Playlist: %@",[playlist name]);
    }*/
    
    //playlistTable = [[NSTableView alloc] init];
    
    selectedPlaylist = -1;
    
    [playlistTable reloadData];
    
    showingSongs = FALSE;
    
    /*NSLog(@"Track: %@",[currentTrack name]);
     NSLog(@"Artist: %@",[currentTrack albumArtist]);*/

}

// Not quite sure which of these two methods are being used. They're similar, but might have different uses
- (void)showSongs; {
    
   // self.playlist =
    ETPlaylist *newPlaylist = [self.playlists objectAtIndex:selectedPlaylist];
    for (ETTrack *track in [newPlaylist tracks]) {
        DJTrack *djTrack = [DJTrack newTrackCalled:[track name] by:[track artist] at:[track getPropertyAsPathForDesc:pETTrackLocation]];
        [self.playlist addObject:djTrack];
    }
    
    //self.playlists = [self.playlist tracks];
    
    [songTable reloadData];
    
    showingSongs = TRUE;
    
    
    
    //NSLog(@"%@", [[self.playlist objectAtIndex:0] title]);
    
    /*for (DJTrack *track in playlist.tracks) {
        
    }*/
    
}

// I think this is used to reload the current playlist
- (void)showSongs:(NSMutableArray *)playlist; {
    
    
    //self.playlist = [self.playlists objectAtIndex:selectedPlaylist];
    
    
    
    //self.playlists = [playlist tracks];
    
    [songTable reloadData];
    
    showingSongs = TRUE;
    
    /*for (DJTrack *track in playlist.tracks) {
     
     }*/
    
}

- (void)addSongToPlaylist:(NSString *)message {
    //EyeTunes *eyetunes = [EyeTunes sharedInstance];
    
    //ETPlaylist *playlist = [self.playlists objectAtIndex:selectedPlaylist];
    
    //ETPlaylist *library = [eyetunes playlists];
    
    //DJTrack *track = [playlist.tracks firstObject];
    
    //NSLog([track getPropertyAsPathForDesc:pDJTrackLocation]);
    
    //NSString *urlString = [NSString stringWithFormat:@"%@", [track getPropertyAsPathForDesc:pDJTrackLocation]];
    
    
    //NSLog(message);
    
    //NSArray *array = [message componentsSeparatedByString:@";"];
    //[voteCount objectAtIndex:(NSUInteger)[track objectAtIndex:3]];
    
    DJTrack *track = [DJTrack makeTrackFromMessage:message];
    
    //NSLog([track objectAtIndex:2]);
    
    //NSURL *url = [NSURL URLWithString:[[track objectAtIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //[eyetunes addTrack:url toPlaylist:self.playlist];
    
    [self.playlist addObject:track];
    
    #pragma warning We have to think of how were going to display the songs
    [self showSongs:self.playlist];

    [self sendSong:message];
    
    //[eyetunes playTrack:track];
}

// Find the received track in the playlist and increment its vote count. There might be a better way of doing this?
- (void)increaseVoteCount:(NSString *)message {
    DJTrack *track = [DJTrack makeTrackFromMessage:message];
    
    NSInteger i = 0;
    for (i=0; i<[self.playlist count]; i++) {
        if ([[[self.playlist objectAtIndex:i] getLocation] caseInsensitiveCompare:track.location] == NSOrderedSame) {
            [[self.playlist objectAtIndex:i] incVoteCount];
            break;
        }
    }
    
    /*for (; i>0; i--) {
        if ([[self.playlist objectAtIndex:i] getVoteCount] > [[self.playlist objectAtIndex:i-1] getVoteCount]) {
            [self.playlist exchangeObjectAtIndex:i withObjectAtIndex:i-1];
        }
    }*/
    
    [self.playlist sortUsingFunction:voteSort context:NULL];
    
    [songTable reloadData];
}

// Used to sort our playlist in descending order.
NSInteger voteSort(id num1, id num2, void *context) {
    
    NSInteger v1 = [num1 getVoteCount];
    NSInteger v2 = [num2 getVoteCount];
    
    // > and < swapped from usual example to descend instead of ascend.
    if (v1 > v2)
        return NSOrderedAscending;
    else if (v1 < v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
    
}

/*- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self->inoutTrack = [decoder decodeObjectForKey:@"track"];
    }
    return self->inoutTrack;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self->inoutTrack forKey:@"track"];
}*/


- (IBAction)connectToService:(id)sender;
{
    NSLog(@"%d", (int) self.playlists.count);
	//[self.server connectToRemoteService:[self.services objectAtIndex:selectedRow]];
}

- (IBAction)sendText:(id)sender;
{
	NSData *data = [textToSend dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	[self.server sendData:data error:&error];
	
    //[self.server s ]
}

- (void)sendSong:(NSString *)encodedSong;
{
	NSData *data = [encodedSong dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	[self.server sendData:data error:&error];
}

- (IBAction)sendSongs:(id)sender; {
    //EyeTunes *eyetunes = [EyeTunes sharedInstance];
    
    //ETPlaylist *library = [eyetunes libraryPlaylist];
    NSError *error = nil;
    
    //NSUInteger i = 0;
    for (DJTrack *track in self.playlist) {
        //DJTrack *djTrack = [DJTrack newFromTrack:track];
        //NSLog(@"2. %ld", (long)djTrack.voteCount);
        
        NSData *data = [[self encodeTrack:track] dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //[encoder encodeObject:self->inoutTrack forKey:@"track"];
        //[NSKeyedArchiver archivedDataWithRootObject:track];
        //[[track name] dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSThread sleepForTimeInterval:0.01f];
        
        NSLog(@"Sending song %@", track.title);
        [self.server sendData:data error:&error];
    }
    
}

// Decodes a string into an DJTrack object we can use
- (DJTrack *)decodeTrack:(NSString *)str; {
    DJTrack *track = nil;
    
    NSArray *array = [str componentsSeparatedByString:@";"];
    
    track.title = [array objectAtIndex:0];
    track.artist = [array objectAtIndex:1];
    //track.location =
    //track.index = [array objectAtIndex:3];
    
    return track;
    
}

// Encodes track title, artist and location into a string so we can send it to the client
- (NSString *)encodeTrack:(DJTrack *)track; {
    NSLog(@"%ld", (long)[track getVoteCount]);
    
    NSString *str = @"";
    
    if (track.title.length > 0) {
        str = [str stringByAppendingString:track.title];
    }
    str = [str stringByAppendingString:@";"];
    
    if (track.artist.length > 0) {
        str = [str stringByAppendingString:track.artist];
    }
    str = [str stringByAppendingString:@";"];
    
    if (track.location.length > 0) {
        str = [str stringByAppendingString:track.location];
    }
    str = [str stringByAppendingString:@";"];
    
    NSString *voteCount = [NSString stringWithFormat:@"%lu", [track getVoteCount]];
    if (voteCount.length > 0) {
        str = [str stringByAppendingString:voteCount];
    }
    str = [str stringByAppendingString:@";"];
    
    return str;
}


- (IBAction)startServer:(id)sender; {
    if (selectedPlaylist == -1) {
        NSLog(@"Please select a playlist");
        return;
    }
    
    NSString *type = @"TestingProtocol";
    
    _server = [[Server alloc] initWithProtocol:type];
    _server.delegate = self;
    
    NSError *error = nil;
    if(![_server start:&error]) {
        NSLog(@"error = %@", error);
    }
    
    //NSLog(@"%@",[[self.playlist objectAtIndex:0] title]);
    NSLog(@"Server started!");
    
    [NSThread detachNewThreadSelector:@selector(monitorTrack) toTarget:self withObject:nil];
    
}

- (void) monitorTrack {
    EyeTunes *eyetunes = [EyeTunes sharedInstance];

    ETTrack *previousTrack = [eyetunes currentTrack];
    
    //NSLog(@"%@", [previousTrack name]);
    
    while (true) {
        ETTrack *currentTrack = [eyetunes currentTrack];
        if ([[currentTrack location] compare:[previousTrack location]] != NSOrderedSame) {
            NSLog(@"Swithing track to: %@", [currentTrack name]);
            [eyetunes playTrackWithPath:[[self.playlist objectAtIndex:0] getLocation]];
            [[self.playlist objectAtIndex:0] setVoteCount:0];
            [self.playlist sortUsingFunction:voteSort context:NULL];
            previousTrack = currentTrack;
        }
        [NSThread sleepForTimeInterval:0.05f];
    }
}


#pragma mark -
#pragma mark Server delegate methods

- (void)serverRemoteConnectionComplete:(Server *)server
{
    NSLog(@"Connected to service");
	
	self.isConnectedToService = YES;
    
    //NSLog(selectedRow);
    
	connectedRow = selectedRow;
	[deviceTable reloadData];
    
    //[self sendSongs:connectedRow];
}

- (void)serverStopped:(Server *)server
{
    NSLog(@"Disconnected from service");
    
	self.isConnectedToService = NO;
    
	connectedRow = -1;
	[deviceTable reloadData];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict
{
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data
{
    NSLog(@"Server did accept data"); // %@", data);
    NSString *message = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if(nil != message || [message length] > 0) {
        self.message = message;
        [self increaseVoteCount:message];
        [self sendSongs:nil];
        NSLog(message);
    } else {
        self.message = @"no data received";
    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict
{
	NSLog(@"Lost connection");
	
	self.isConnectedToService = NO;
	connectedRow = -1;
	[deviceTable reloadData];
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more
{
	NSLog(@"Added a service: %@", [service name]);
	
    [self.services addObject:service];
    if(!more) {
        [deviceTable reloadData];
    }
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more
{
	NSLog(@"Removed a service: %@", [service name]);
	
    [self.services removeObject:service];
    if(!more) {
        [deviceTable reloadData];
    }
}

#pragma mark -
#pragma mark NSTableView delegate methods

/*- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if (rowIndex == connectedRow)
		[aCell setTextColor:[NSColor redColor]];
	else
		[aCell setTextColor:[NSColor blackColor]];
}*/

/*- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	return [[self.playlists objectAtIndex:rowIndex] name];
}*/

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (aTableView == playlistTable) {
        //NSLog(@"Count: %lu", (unsigned long)[self.playlists count]);
        return (int) [self.playlists count];
    }
    if (aTableView == songTable) {
        return (int) [self.playlist count];
    }
    return (int) [self.services count];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
{
    //NSLog([[aNotification object] identifier]);
    if ([[[aNotification object] identifier] isEqualToString:@"PlaylistsTable"] && !showingSongs) {
        //NSLog(@"Here2");
        selectedPlaylist = [[aNotification object] selectedRow];
        [self showSongs];
    } else {
        selectedRow = [[aNotification object] selectedRow];
    }
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    return YES;
}

/*- (NSString *)tableView:(NSTableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"title");
    return [[self.playlists sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}*/

- (NSTableCellView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    //NSLog(@"Here");
    //NSLog(@"%ld", (long)row);
    //NSLog([self.playlists firstObject]);
    //[self.playlists firstObject];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    //[cellView setTitle:[array objectAtIndex:row]];
   
    //NSTextField *field;
    
    //[field setStringValue:[self.playlists objectAtIndex:row]];
    
    //[cellView setTextField:field];

    //return Nil;
    
    //NSLog(tableColumn.identifier);
    
    if( [tableColumn.identifier isEqualToString:@"Playlists"] )
    {
        cellView.textField.stringValue = [[self.playlists objectAtIndex:row] name ];
        return cellView;
    }
    
    if ( [tableColumn.identifier isEqualToString:@"Devices"] ) {
        cellView.textField.stringValue = [[self.services objectAtIndex:row] name];
        return cellView;
    }
    
    if ( [tableColumn.identifier isEqualToString:@"Songs"] ) {
        NSLog(@"%@", [[self.playlist objectAtIndex:row] title]);
        //[[self.playlist objectAtIndex:row] title;
        cellView.textField.stringValue = [[self.playlist objectAtIndex:row] title];
        return cellView;
    }
    
    if ( [tableColumn.identifier isEqualToString:@"Votes"] ) {
        cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", [[self.playlist objectAtIndex:row] voteCount]];
        return cellView;
    }
    
    //cellView.textField.stringValue = [[self.playlists objectAtIndex:row] name ];
    return cellView;
}


@synthesize server = _server;
@synthesize services = _services;
@synthesize message = _message;
@synthesize playlist = _playlist;
@synthesize isConnectedToService;

@end
