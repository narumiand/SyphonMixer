//
//  stackView.m
//  SyphonMixer
//
//  Created by Narumi on 2017/03/03.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stackView.h"


@implementation stackView

@synthesize FPS;

@synthesize frameWidth;

@synthesize frameHeight;




-(instancetype)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        // setup the initial properties of the
        // draggable item
        //[self setItemPropertiesToDefault:self];
        [[NSBundle mainBundle] loadNibNamed:@"StackView" owner:self topLevelObjects:nil];
        NSRect contentFrame = NSMakeRect(0,0,self.frame.size.width,self.frame.size.height);
        self->_view.frame = contentFrame;
        [self addSubview:self->_view];
        
        
        [_infoLabel setTextColor:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0 ] ];
        
        
    }
    return self;
}

- (void) setup:(NSDictionary*) description {
    
    [syClient stop];
    
    syClient = [[SyphonClient alloc] initWithServerDescription:description options:nil newFrameHandler:^(SyphonClient *client){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // First we track our framerate...
           /* fpsCount++;
            float elapsed = [NSDate timeIntervalSinceReferenceDate] - fpsStart;
            if (elapsed > 1.0)
            {
                self->FPS = ceilf(fpsCount / elapsed);
                fpsStart = [NSDate timeIntervalSinceReferenceDate];
                fpsCount = 0;
            }*/
            // ...then we check to see if our dimensions display or window shape needs to be updated
            SyphonImage *frame = [client newFrameImageForContext:[[simpleView openGLContext] CGLContextObj]];
            
            //NSSize imageSize = frame.textureSize;
            
            //_infoLabel.placeholderString = [NSString stringWithFormat:@"%d x %d fps:%lu",(int)imageSize.width,(int)imageSize.height,(unsigned long)FPS];
            
            simpleView.image = frame;
            
            [simpleView setNeedsDisplay:YES];
            
        }];
    }];
    
    // If we have a client we do nothing - wait until it outputs a frame
    
    // Otherwise clear the view
    if (syClient == nil)
    {
        simpleView.image = nil;
        
        self.frameWidth = 0;
        self.frameHeight = 0;
        
        [simpleView setNeedsDisplay:YES];
    }


}


- (IBAction)alphaControl:(id)sender {
    //[monitor setAlphaValue: [_alphaControlBar floatValue] ];
    //[output setAlphaValue: [_alphaControlBar floatValue] ];
}
@end
