//
//  AppDelegate.m
//  SyphonMixer
//
//  Created by Narumi on 2017/03/02.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [fullScreenMenu removeAllItems];
    
    NSArray<NSScreen*> *screens = [ NSScreen screens ];
    
    for(NSUInteger i = 0; i < [screens count]; i++){
        
        if([screens objectAtIndex:i] == [NSScreen mainScreen]){
            [fullScreenMenu addItemWithTitle:@"Main Screen" action:nil keyEquivalent:@""];
        }else{
            NSDictionary* displayID = [[screens objectAtIndex:i] deviceDescription];
            NSMenuItem *item = [[NSMenuItem alloc] init];
            item.title = [[NSString alloc] initWithFormat:@"Screen: %@",displayID ];
            item.representedObject = [screens objectAtIndex:i];
            item.action = @selector(itemClicked:);
            
            [fullScreenMenu addItem:item];
        }
    }
}

-(void)itemClicked:(NSMenuItem*)sender{
    NSScreen* screen = sender.representedObject;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemcd" object:screen];
}

-(void) applicationDidChangeScreenParameters:(NSNotification *)notification{
    [fullScreenMenu removeAllItems];
    
    NSArray<NSScreen*> *screens = [ NSScreen screens ];
    
    for(NSUInteger i = 0; i < [screens count]; i++){
        
        if([screens objectAtIndex:i] == [NSScreen mainScreen]){
            [fullScreenMenu addItemWithTitle:@"Main Screen" action:nil keyEquivalent:@""];
        }else{
            NSDictionary* displayID = [[screens objectAtIndex:i] deviceDescription];
            NSMenuItem *item = [[NSMenuItem alloc] init];
            item.title = [[NSString alloc] initWithFormat:@"Screen: %d",displayID ];
            item.representedObject = [screens objectAtIndex:i];
            item.action = @selector(itemClicked:);
            
            [fullScreenMenu addItem:item];
        }
        
        
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"willTerminate" object:nil];
}




//-(void)application


@end
