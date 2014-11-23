//
//  MazeCell.m
//  speed-maze
//
//  Created by littlebeef on 11/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MazeCell.h"
#import "GameScene.h"

@interface MazeCell()

@end


@implementation MazeCell

-(void)dealloc{
    self.parent = nil;
}

-(instancetype)init{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.visited = NO;
    self.discorver = 0;
    return self;
}


-(instancetype)initWithX:(int)x Y:(int)y{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.visited = NO;
    self.discorver = 0;
    self.x = x;
    self.y = y;
    self.parent = nil;
    return self;
}



-(void)visit{
    
    self.visited = YES;
}

-(int)score{
    int total = 0;
    MazeCell *thisParent = self.parent;
    while (thisParent) {
        total++;
        thisParent = thisParent.parent;
    }
    return total;
}

-(NSArray *)pathToOrigin{
    NSMutableArray *path = [[NSMutableArray alloc] initWithObjects:self, nil];
    MazeCell *thisParent = self.parent;
    while (thisParent) {
        [path addObject:thisParent];
        thisParent = thisParent.parent;
    }
    return [[path reverseObjectEnumerator] allObjects];
}

@end


