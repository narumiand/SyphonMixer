//
//  ViewController.m
//  SyphonMixer
//
//  Created by Narumi on 2017/03/02.
//  Copyright © 2017年 Narumi Inada. All rights reserved.
//

#import "ViewController.h"
@interface customResponder : NSResponder {
    
}
@end

@implementation customResponder

-(void) keyDown:(NSEvent *)event{
    int a = 0;
}

@end

@interface OnlyIntegerValueFormatter : NSNumberFormatter

@end

@implementation OnlyIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    
    return YES;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   // customResponder *resp;
    
    //resp = [[customResponder alloc] init];
    
    syDir = [SyphonServerDirectory sharedDirectory];
    
   [syDir addObserver:self forKeyPath:@"servers" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    stackSize = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemcd:) name:@"itemcd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:@"willTerminate" object:nil];
    
    sharedContext = [[NSOpenGLContext alloc] initWithFormat:[NSOpenGLView defaultPixelFormat] shareContext:nil];
    
    [monitorView setOpenGLContext:sharedContext];
    [outputView setOpenGLContext:sharedContext];
    
    NSDictionary *options = @{SyphonServerOptionDepthBufferResolution: @16};
    syServer = [[SyphonServer alloc] initWithName:nil context:[sharedContext CGLContextObj] options:options];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(publish:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //OnlyIntegerValueFormatter *formatter = [[OnlyIntegerValueFormatter alloc] init];
    //[_frameWidth setFormatter:formatter];
    //[_frameHeight setFormatter:formatter];
    
    serverFrame = NSMakeSize(1920, 1080);
    needsReshape = YES;
}

-(void)viewWillDisappear{
    [syServer stop];
}




-(void) publish:(NSTimer*)timer{
    
    CGLSetCurrentContext([sharedContext CGLContextObj]);
    NSSize frameSize = serverFrame;
    
    if([syServer context] != NULL){
    [syServer bindToDrawFrameOfSize:serverFrame];
            // Make the window the target
    
    
        glEnable(GL_BLEND);
        //glBlendFunc(GL_ONE, GL_ONE);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glClearColor(0, 0, 0, 1.0);

        glClear(GL_DEPTH_BUFFER_BIT);
        glClear(GL_COLOR_BUFFER_BIT);
    
        //if(needsReshape){
            glViewport(0, 0, frameSize.width, frameSize.height);
    
            glMatrixMode(GL_PROJECTION);
            glLoadIdentity();
            glOrtho(0.0, frameSize.width, 0.0, frameSize.height, -1, 1);
    
            glMatrixMode(GL_MODELVIEW);
            glLoadIdentity();
    
            glTranslated(frameSize.width * 0.5, frameSize.height * 0.5, 0.0);
           // [sharedContext update];
          //  needsReshape = NO;
        //}
    
        glEnable(GL_TEXTURE_RECTANGLE_EXT);
        glEnableClientState( GL_TEXTURE_COORD_ARRAY );
        glEnableClientState(GL_VERTEX_ARRAY);
    
    
        NSArray* array = [serverStackView views];
        for(NSUInteger i = 0; i < [array count]; i++){
            
            stackView* tmpView = [array objectAtIndex:i];
            
            //[tmpView->simpleView drawRect:NSMakeRect(0,0,serverFrame.width,serverFrame.height)];
            
            
            SyphonImage *image = tmpView->simpleView.image;
            
            if (image)
            {
                
                
                
                
                glBindTexture(GL_TEXTURE_RECTANGLE_EXT, image.textureName);
                
                NSSize textureSize = image.textureSize;
                
                glColor4f(1.0, 1.0, 1.0, (GLfloat)[tmpView.alphaControlBar floatValue]);
                
                
                
                GLfloat tex_coords[] =
                {
                    0.0,                0.0,
                    textureSize.width,  0.0,
                    textureSize.width,  textureSize.height,
                    0.0,                textureSize.height
                };
                
                float halfw = serverFrame.width/2;
                float halfh = serverFrame.height/2;
                
                GLfloat verts[] =
                {
                    -halfw, -halfh,
                    halfw, -halfh,
                    halfw, halfh,
                    -halfw, halfh
                };
                
                
                glTexCoordPointer(2, GL_FLOAT, 0, tex_coords );
                
                glVertexPointer(2, GL_FLOAT, 0, verts );
                glDrawArrays( GL_TRIANGLE_FAN, 0, 4 );
                
                
                
                
                
             
            }
            
        }
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
        glDisableClientState( GL_TEXTURE_COORD_ARRAY );
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisable(GL_TEXTURE_RECTANGLE_EXT);
    
    
    
        [syServer unbindAndPublish];
        
        SyphonImage* image = [syServer newFrameImage];
        
    
        if([outputView isInFullScreenMode])outputView.image = image;
        monitorView.image = image;
        
        
    
        if([outputView isInFullScreenMode])[outputView setNeedsDisplay:YES];
    
        [monitorView setNeedsDisplay:YES];

    }
    
}

-(void) itemcd:(NSNotification*)Notification{
    NSScreen * screen = Notification.object;
    NSDictionary<NSString *,id> * options = @{NSFullScreenModeAllScreens: [NSNumber numberWithInt:0],NSFullScreenModeWindowLevel:[NSNumber numberWithInt:0]  };
    
    if([outputView isInFullScreenMode]){
        [outputView exitFullScreenModeWithOptions:nil];
    }else{
        [outputView enterFullScreenMode:screen withOptions:options];
        //[outputView setNeedsDisplay:YES];
        
    }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"servers"]) {
        
        NSArray* newServers = [change objectForKey:NSKeyValueChangeNewKey];
        NSArray* oldServers = [change objectForKey:NSKeyValueChangeOldKey];
        
        if([oldServers count] < [newServers count]){//increase
        
            NSUInteger count = [newServers count];
        
            for(NSUInteger i = 0; i < count; i++){
            
                BOOL isNew = YES;
                for(NSUInteger j = 0; j < [oldServers count]; j++){
                    if([[newServers objectAtIndex:i] isEqual:[oldServers objectAtIndex:j]]){
                        isNew = NO;
                        break;
                    }
                }
                
                if([[[newServers objectAtIndex:i] valueForKey:@"SyphonServerDescriptionAppNameKey"] isEqualToString:@"SyphonMixer"]){
                    isNew = NO;
                }
                    
                    
                if(isNew){
                    
                    stackView* tmpView = [[stackView alloc] initWithFrame:NSMakeRect(0, 60*stackSize++, 400, 60)];
                
                    [tmpView setup:[newServers objectAtIndex:i]];
                
                    
                    [tmpView->simpleView setOpenGLContext:sharedContext];
                    
                    [serverStackView addView:tmpView inGravity:NSStackViewGravityLeading];
                    
                }
            }
        }else{
                    
            NSArray *array = [serverStackView views];
                    
            for(NSUInteger i = 0; i < [array count]; i++){
                        
                stackView* tmpView = [array objectAtIndex:i];
                BOOL exist = YES;
                        
                for(NSUInteger j = 0; j < [oldServers count]; j++){
                            
                    NSString * name = [[tmpView->syClient serverDescription] objectForKey:SyphonServerDescriptionNameKey];
                    NSString * appName = [[tmpView->syClient serverDescription] objectForKey:SyphonServerDescriptionAppNameKey];
                            
                    NSString * sName = [ [oldServers objectAtIndex:j] objectForKey:SyphonServerDescriptionNameKey];
                    NSString * sAppName = [ [oldServers objectAtIndex:j] objectForKey:SyphonServerDescriptionAppNameKey];
                            
                    if([name isEqualToString:sName] && [appName isEqualToString:sAppName] ){
                        exist = NO;
                        break;
                    }
                            
                }
                if(!exist){
                    
                    
                    [serverStackView removeView:tmpView];
                }
            }
        }
    }
}

-(void)keyDown:(NSEvent *)event{
    int a = 0;
}

-(void)viewDidAppear {
    
    
    

    
}

-(void)serverAnnounced:(NSNotification*)notify{
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)AlphaControl:(id)sender {
}

- (IBAction)ContrastControl:(id)sender {
}

- (IBAction)BlightnessControl:(id)sender {
}
- (IBAction)frameWidthChanged:(NSTextField *)sender {
    //serverFrame = NSMakeSize(sender.intValue,serverFrame.height);
}

- (IBAction)frameHeightChanged:(NSTextField *)sender {
    //serverFrame = NSMakeSize(serverFrame.width,sender.intValue);
}

-(void)willTerminate:(NSNotification*)notification{
    [timer invalidate];
    [syServer stop];
}

@end
