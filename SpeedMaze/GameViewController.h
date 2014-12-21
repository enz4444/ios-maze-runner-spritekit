//
//  GameViewController.h
//  SpeedMaze
//

//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "MazeGenerator.h"
#import "GameScene.h"
#import "MazeScene.h"
#import "GamepadScene.h"
#import "MenuScene.h"

/**
 *  skView(self.view) -> mazeSKView -> mazeScene
 *                    -> controlpadSKView -> GamepadScene
 */
@interface GameViewController : UIViewController <GamepadSceneDelegate,MazeGameMenuDelegate, MazeSceneGameConditionDelegate>

/**
 *  jsut use this in the delegate method to call instance methods, 
 *  and also fade in after game menu
 */
@property (strong, nonatomic) MazeScene *mazeScene;
@property (strong, nonatomic) MenuScene *menuScene;
@property (weak, nonatomic) SKView *mazeSKView;
@property (strong, nonatomic) MazeGenerator *mazeMaze;

@end
