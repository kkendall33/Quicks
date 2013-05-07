//
//  DazFireworksController.h
//  Dazzle
//
//  Created by Leonhard Lichtschlag on 14/Feb/12.
//  Copyright (c) 2012 Leonhard Lichtschlag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

// ===============================================================================================================
@interface DazFireworksController : UIViewController
// ===============================================================================================================

@property CGFloat birthRate;


-(void) makeFireworksWithBirthRate:(CGFloat)birthrate andEmitter:(CAEmitterLayer *)emitter;
-(void) disableFireworksWithEmitter:(CAEmitterLayer *)emitter;

@end


