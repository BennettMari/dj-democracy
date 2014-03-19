//
//  DJTrack.h
//  DJDemocracyServer
//
//  Created by Renan Greca on 2/11/14.
//
//

#import <Foundation/Foundation.h>

@interface DJTrack : NSObject

@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSString *artist;
@property (readwrite, copy) NSString *location;
@property  NSInteger voteCount;

+ (id) newTrackCalled:(NSString *)title by:(NSString *)artist at:(NSString *)location;

+ (id) makeTrackFromMessage:(NSString *)message;

+ (NSString*) makeMessageFromTrack:(DJTrack*) track;

- (NSInteger) getVoteCount;

- (void) setVoteCount:(NSInteger)voteCount;

- (void) incVoteCount;

- (NSString *) getTitle;

- (NSString *) getArtist;

- (NSString *) getLocation;

@end
