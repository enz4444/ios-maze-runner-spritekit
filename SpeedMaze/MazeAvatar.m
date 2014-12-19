//
//  MazeAvatar.m
//  SpeedMaze
//
//  Created by littlebeef on 12/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MazeAvatar.h"

@interface MazeAvatar()

@property (strong,nonatomic) NSMutableArray *undoStepArray;
@property (strong,nonatomic) NSMutableArray *undoDirectionArray;

@end

@implementation MazeAvatar

-(instancetype)init{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.avatarType = mazeAvatarUndefined;
    self.undoStepArray = nil;
    return  self;
}

-(instancetype)initWithAvatarType:(mazeAvatarType)avatarType{
    self = [self init];
    self.avatarType = avatarType;
    if (self.avatarType == mazeAvatarBlackBox) {
        //init an array of maze cells for undo button
        self.undoStepArray = [NSMutableArray array];
        self.undoDirectionArray = [NSMutableArray array];

    }
    return self;
}

-(void)mazeAvatarMove:(MazeGraph *)mazeGraph inDirection:(NSString *)keyname fromLocation:(MazeCell *)avatarMazeCell toLocation:(MazeCell *)toCell{
    if (self.avatarType == mazeAvatarBlackBox) {
        
    }
}

-(void)mazeAvatarBlackBoxStepAt:(MazeCell *)atCell{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    
    [self.undoStepArray addObject:atCell];
}

-(MazeCell *)mazeAvatarBlackBoxUndoACell{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    MazeCell *returnCell = [self.undoStepArray lastObject];
    if (self.undoStepArray.count == 1) {
        return returnCell;
    }
    [self.undoStepArray removeLastObject];
    return returnCell;
}

-(void)mazeAvatarBlackBoxStepTo:(NSString *)atDirection{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    
    [self.undoDirectionArray addObject:atDirection];
}

-(NSString *)mazeAvatarBlackBoxUndoADirection{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    if (self.undoStepArray.count == 0) {
        return nil;
    }
    NSString *returnDirection = [self.undoStepArray lastObject];
    if ([returnDirection isEqualToString:@"U"]) {
        returnDirection = @"D";
    }
    else if ([returnDirection isEqualToString:@"L"]) {
        returnDirection = @"R";
    }
    else if ([returnDirection isEqualToString:@"D"]) {
        returnDirection = @"U";
    }
    else if ([returnDirection isEqualToString:@"R"]) {
        returnDirection = @"L";
    }
    else{
        NSLog(@"direction should be only direction but receive: %@",returnDirection);
    }
    [self.undoStepArray removeLastObject];
    return returnDirection;
}


@end