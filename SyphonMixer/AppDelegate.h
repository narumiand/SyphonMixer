//
//  AppDelegate.h
//  SyphonMixer
//
//  Created by Narumi on 2017/03/02.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Syphon/Syphon.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    __weak IBOutlet NSMenu *fullScreenMenu;
    
}

-(void) itemClicked:(NSMenuItem*)sender;
- (void)keyDown:(NSEvent *)event;
@end

