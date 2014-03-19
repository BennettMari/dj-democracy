//
//  ViewController.m
//  DJDemocracyClient
//
//  Created by Andrew Russell on 12/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController()
@property(nonatomic, retain) NSMutableArray *services;
@end

@implementation ServerViewController

@synthesize services = _services;
@synthesize server = _server;

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 //   return @"Current DJs";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.services objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.server connectToRemoteService:[self.services objectAtIndex: indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated: NO];
    [self.navigationController pushViewController:self.overviewViewController animated:YES];
}





#pragma mark - Service updates

- (void)addService:(NSNetService *)service moreComing:(BOOL)more {
    [self.services addObject:service];
}

- (void)removeService:(NSNetService *)service moreComing:(BOOL)more {
    [self.services removeObject:service];
}

#pragma mark - View lifecycle

- (IBAction)unwindToServers:(UIStoryboardSegue *)segue{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View is loading");
    self.services = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.title = @"Service Browser";
    self.services = nil;
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.services = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addServer:(NSNetService *)service moreComing:(BOOL)more;
{
    //NSLog(@"%@", service.name);
    [self.services addObject:service];
    if(!more) {
        [self.tableView reloadData];
    }
}
- (void)removeServer:(NSNetService *)service moreComing:(BOOL)more; {
    [self.services removeObject:service];
    if(!more) {
        [self.tableView reloadData];
    }
}

#pragma mark - Server accessors

- (NSMutableArray *) services {
    if (nil == _services) {
        self.services = [NSMutableArray array];
    }
    return _services;
}

- (void)dealloc {
    self.services = nil;
    self.server = nil;
    [super dealloc];
}

@end
