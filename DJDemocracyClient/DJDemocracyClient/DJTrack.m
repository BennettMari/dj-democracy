//
//  DJTrack.m
//  DJDemocracyServer
//
//  Created by Renan Greca on 2/11/14.
//
//

#import "DJTrack.h"

@implementation DJTrack

+ (id) newTrackCalled:(NSString *)title by:(NSString *)artist at:(NSString *)location
{
    DJTrack *track =  [[self alloc] init];
    track.title = [NSString stringWithString:title];
    track.artist = [NSString stringWithString:artist];
    track.location = [NSString stringWithString:location];
    track.voteCount = 0;
    return track;
}

+ (id) makeTrackFromMessage:(NSString *)message
{
    NSArray *array = [message componentsSeparatedByString:@";" ];
    return [DJTrack newTrackCalled:[array objectAtIndex:0] by:[array objectAtIndex:1] at:[array objectAtIndex:2]];
}

+ (NSString*) makeMessageFromTrack:track {
    NSString *str = @"";
    str = [str stringByAppendingString:[track getTitle]];
    str = [str stringByAppendingString:@";"];
    str = [str stringByAppendingString:[track getArtist]];
    str = [str stringByAppendingString:@";"];
    str = [str stringByAppendingString:[track getLocation]];
    str = [str stringByAppendingString:@";"];
    //Stuff about current votecount
    return str;
}

- (void) incVoteCount {
    self->_voteCount = self->_voteCount + 1;
}

#pragma mark Setters

- (void) writeVoteCount:(NSInteger)voteCount {
    self->_voteCount = voteCount;
}

#pragma mark Getters

- (NSInteger) getVoteCount {
    return self->_voteCount;
}

- (NSString *) getTitle {
    return self.title;
}

- (NSString *) getArtist {
    return self.artist;
}

- (NSString *) getLocation {
    return self.location;
}

@end
