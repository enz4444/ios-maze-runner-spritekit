//
//  GameViewController.m
//  SpeedMaze
//
//  Created by littlebeef on 11/20/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (ZenDebug>=2) {
        NSLog(@"Enter GameVC viewDidLoad");
    }
    
    if (true) {
        //main view
        SKView * skView = (SKView *)self.view;
        skView.ignoresSiblingOrder = YES;

        //maze view
        SKView * mazeSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, ZenSW, ZenSW)];
        mazeSKView.showsFPS = YES;
        mazeSKView.showsDrawCount = YES;
        mazeSKView.showsQuadCount = YES;
        mazeSKView.showsPhysics = YES;
        mazeSKView.showsFields = YES;
        mazeSKView.showsNodeCount = YES;
        mazeSKView.ignoresSiblingOrder = YES;
        self.mazeSKView = mazeSKView;
        
        //gamepad view
        SKView * controlpadSKView = [[SKView alloc] initWithFrame:CGRectMake(0, ZenSW, ZenSW, ZenSW/3)];
        
        //gamepad scene
        GamepadScene *gamepadScene = [[GamepadScene alloc] initWithSize:CGSizeMake(ZenSW, ZenSW/3)];
        gamepadScene.gamepadDelegate = self;
        
        MenuScene *menuScene = [[MenuScene alloc] initMazeGameMenuWithSize:mazeSKView.bounds.size];
        menuScene.gameMenudelegate = self;
        self.menuScene = menuScene;
        //add all subview to main view
        [skView addSubview:mazeSKView];
        [skView addSubview:controlpadSKView];

        //present all scene to their subview
        [mazeSKView presentScene:menuScene];
        [controlpadSKView presentScene:gamepadScene];
        
        NSLog(@"casted skView: %f, %f, %f, %f",skView.frame.origin.x,skView.frame.origin.y,skView.frame.size.width,skView.frame.size.height);
    }
    else{
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
        skView.showsDrawCount = YES;
        skView.showsQuadCount = YES;
        skView.showsPhysics = YES;
        skView.showsFields = YES;
        skView.showsNodeCount = YES;
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [skView presentScene:scene];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (ZenDebug>=2) {
        NSLog(@"Enter GameVC viewDidAppear");
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)returnToMainMenu{
    //back to main menu
    self.mazeMaze = nil;
    self.mazeScene = nil;
    SKTransition *reveal = [SKTransition fadeWithDuration:1];
    [self.mazeSKView presentScene:self.menuScene transition:reveal];
}

/**
 *  GamepadSceneDelegate
 *
 *  @param keyName direction key
 */
-(void)gamepadKeyTouched:(NSString *)keyName{
    if ([keyName isEqualToString:@"Q"]) {
        [self returnToMainMenu];
    }
    else{
        if (self.mazeScene != nil) {
            [self.mazeScene gamepadControlMoveTo:keyName];
        }
    }
}

/**
 *  MazeGameMenuDelegate
 */
-(void)generateMazeWithWidth:(int)width andHeight:(int)height andAvatarType:(mazeAvatarType)avataType{
    @try {
        self.mazeMaze = [[MazeGenerator alloc] initMazeWithWidth:width height:height];
        [self.mazeMaze defaultMaze];
        
        /*
         scene type: N x N
         N<50
         one screen fits all -> SKSceneScaleModeAspectFit
         otherwise square lenth no les than width/15
         
         */
        
        //fade in mazeScene
        self.mazeScene = [[MazeScene alloc] initWithMaze:self.mazeMaze andScreenSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width) andAvatarType:avataType];
        
        self.mazeScene.scaleMode = SKSceneScaleModeAspectFill;

        self.mazeScene.gameConditionDelegate = self;
        self.mazeScene.backgroundColor = [UIColor whiteColor];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.1];
        [self.mazeSKView presentScene:self.mazeScene transition:reveal];
        
        
        //print solution path
        if (ZenDebug>=3) {
            for (MazeCell *step in self.mazeMaze.path) {
                NSLog(@"(%i,%i)",step.x,step.y);
            }
        }
        
        //ASCII maze no right,bottom walls // ⅃
        if (ZenDebug>=3) {
            for (int j = 0; j < height-1; j++) {
                NSString *row = @"";
                for (int i = 0; i < width-1; i++) {
                    if(![self.mazeMaze.mazeGraph areConnectedBetween:((MazeCell *)self.mazeMaze.mazeGraph.cells[i][j]) and:((MazeCell *)self.mazeMaze.mazeGraph.cells[i+1][j])]){
                        if(![self.mazeMaze.mazeGraph areConnectedBetween:((MazeCell *)self.mazeMaze.mazeGraph.cells[i][j]) and:((MazeCell *)self.mazeMaze.mazeGraph.cells[i][j+1])]){
                            row=[row stringByAppendingString:@" "];
                        }
                        else{
                            row=[row stringByAppendingString:@"_"];
                        }
                    }
                    else{
                        if(![self.mazeMaze.mazeGraph areConnectedBetween:((MazeCell *)self.mazeMaze.mazeGraph.cells[i][j]) and:((MazeCell *)self.mazeMaze.mazeGraph.cells[i][j+1])]){
                            row=[row stringByAppendingString:@"|"];
                        }
                        else{
                            row=[row stringByAppendingString:@">"];
                        }
                    }
                }
                NSLog(@"%@",row);
            }
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error: failure to generate default maze. \nDescription: %@", exception.description);
        
    }
    @finally {
        
    }

    
}

/**
 *  MazeSceneGameConditionDelegate
 */
-(void)mazeSceneGameEnds:(NSString *)condition{
    [self returnToMainMenu];
}

@end
