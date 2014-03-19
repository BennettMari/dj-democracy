//
//  SongViewController.m
//  DJDemocracyClient
//
//  Created by Andrew Russell on 12/17/13.
//
//
#import "ServerViewController.h"
#import "SongViewController.h"
#import "DJTrack.h"

@interface SongViewController ()
@property(nonatomic, retain) NSMutableArray *songs;
@end

@implementation SongViewController

@synthesize songs = _songs;
@synthesize server = _server;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) addSong:(NSString *)message {
    NSArray *track = [message componentsSeparatedByString:@";" ];
    
    NSLog(@"Adding song %@", [track objectAtIndex:0]);
    
    [self.songs addObject:track];
    //NSLog(@"Count of songs: %d", self.songs.count);
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.title = @"Service Browser";
    self.songs = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)unwindToOverview:(UIStoryboardSegue *)segue{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView //titleForHeaderInSection:(NSInteger)section {
  //  return @"Songs Available";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Count of songs: %d", self.songs.count);
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    //NSLog(@"Something something");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.songs objectAtIndex:indexPath.row] objectAtIndex:3];
    cell.textLabel.text = [cell.textLabel.text stringByAppendingString:[[self.songs objectAtIndex:indexPath.row] objectAtIndex:0]];
    //[[self.songs objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //#WARNING : This isn't the right place for the remote server. 
    [self.server connectToRemoteService:[[((ServerViewController *)self.presentingViewController)
                                          services] objectAtIndex:0]];
    NSError *error = nil;
    
    DJTrack *track = [self.songs objectAtIndex:indexPath.row];
    
    NSString *str = @"";
    str = [str stringByAppendingString:[DJTrack makeMessageFromTrack:track]];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //[encoder encodeObject:self->inoutTrack forKey:@"track"];
    //[NSKeyedArchiver archivedDataWithRootObject:track];
    
    //[[track name] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Sending song");
    
    [self.server sendData:data error:&error];
    self.songs = [[NSMutableArray alloc] init];

}

@end
