//
//  FCAnimateView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/16.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "FCAnimateView.h"

@implementation FCAnimateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
            CALayer *layeraaa = [CALayer layer];
            layeraaa.frame = self.bounds;
            layeraaa.backgroundColor = [UIColor blueColor].CGColor;
            [self.layer addSublayer:layeraaa];

        //创建圆环
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:150 startAngle:0 endAngle:M_PI clockwise:YES];
        //圆环遮罩
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapeLayer.lineWidth = 10;
            shapeLayer.strokeStart = 0;
            shapeLayer.strokeEnd = 1;
            shapeLayer.lineCap = kCALineCapRound;
            shapeLayer.lineDashPhase = 0.8;
            shapeLayer.path = bezierPath.CGPath;
            [layeraaa setMask:shapeLayer];
            
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
            rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
            rotationAnimation.repeatCount = 2;
            rotationAnimation.duration = 1;
            rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationAnimation.fillMode = kCAFillModeForwards;
            [layeraaa addAnimation:rotationAnimation forKey:@"rotation"];
        
    }
    return self;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
