//
//  MazeGenerator.h
//  speed-maze
//
//  Created by Enlan Zhou on 11/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MazeGenerator : NSObject

//-(NSArray *)generateMazeWithRow:(int)row column:(int)column;

//-(instancetype)generateMazeWithRow:(int)row column:(int)column;

-(instancetype)initMazeWithWidth:(int)width height:(int)height;

@end

