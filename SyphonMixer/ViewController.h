//
//  ViewController.h
//  SyphonMixer
//
//  Created by Narumi on 2017/03/02.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Syphon/Syphon.h> 
#import "SimpleImageView.h"
#import "stackView.h"

@interface ViewController : NSViewController
{
    
    NSTimer* timer;
    NSSize serverFrame;
     int stackSize;
    IBOutlet NSStackView *serverStackView;
    IBOutlet NSScrollView *serverListView;
    IBOutlet SimpleImageView *monitorView;

    SyphonServerDirectory *syDir;
    
    IBOutlet SimpleImageView *outputView;
    BOOL needsReshape;
    NSArray* servers;
    
    SyphonServer* syServer;

    NSOpenGLContext* sharedContext;
    NSMutableArray* discriptions;
}

- (IBAction)BlightnessControl:(id)sender;


- (void)keyDown:(NSEvent *)event;



@end

