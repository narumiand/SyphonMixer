//
//  stackView.h
//  SyphonMixer
//
//  Created by Narumi on 2017/03/03.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#ifndef stackView_h
#define stackView_h
#import <Cocoa/Cocoa.h>
#import <Syphon/Syphon.h>
#import "SimpleImageView.h"

@interface stackView : NSView <NSApplicationDelegate>{
    @public
    
    IBOutlet SimpleImageView *simpleView;
    
    SyphonClient * syClient;
    
    NSTimeInterval fpsStart;
    NSUInteger fpsCount;
    NSUInteger FPS;
    NSUInteger frameWidth;
    NSUInteger frameHeight;
   
}


@property (strong) IBOutlet NSPopUpButton *blendingPopup;
@property (strong) IBOutlet NSTextField *infoLabel;

@property (readwrite) NSUInteger index;

@property (readwrite, assign) NSUInteger FPS;
@property (readwrite, assign) NSUInteger frameWidth;
@property (readwrite, assign) NSUInteger frameHeight;


@property (weak) IBOutlet NSView *view;

@property (strong) IBOutlet NSSlider *alphaControlBar;
- (IBAction)alphaControl:(id)sender;
-(void) setup:(NSArray*)servers;


@end

#endif /* stackView_h */
