#import "CleverSDK.h"
#import <PocketSVG.h>

const CGFloat CleverLoginButtonBaseWidth = 240.0;
const CGFloat CleverLoginButtonBaseHeight = 52.0;

@interface CleverLoginButton ()

@property (nonatomic, strong) UIImageView *textImage;

@property (nonatomic, strong) NSString *districtId;

@end

@implementation CleverLoginButton

+ (CleverLoginButton *)createLoginButton {
    CleverLoginButton *button = [CleverLoginButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CleverLoginButtonBaseWidth, CleverLoginButtonBaseHeight);
    
    UIImage *bgImage = [CleverLoginButton backgroundImageForButton];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setImage:[CleverLoginButton cleverIconWithSize:button.bounds.size] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button.layer setShadowColor:UIColor.blackColor.CGColor];
    [button.layer setShadowOpacity:0.25];
    [button.layer setShadowRadius:4.0];
    [button.layer setShadowOffset:CGSizeMake(-1.0, 1.0)];
    
    button.textImage = [[UIImageView alloc] initWithImage:[CleverLoginButton textForButton:button.frame.size]];
    button.textImage.frame = button.bounds;
    [button addSubview:button.textImage];
    
    [button addTarget:button action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(width, frame.size.height);
    self.frame = frame;
    
    // need to adjust the text too
    self.textImage.image = [CleverLoginButton textForButton:self.frame.size];
    self.textImage.frame = self.bounds;
}

- (void)loginButtonPressed:(id)loginButton {
    [CleverSDK login];
}

+ (UIImage *)backgroundImageForButton {
    UIColor *color = [UIColor colorWithRed:(100.0/255.0) green:(134.0/255.0) blue:(248.0/255.0) alpha:1.0];
    CGFloat cornerRadius = 4.0;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat size = 1.0 + 2 * cornerRadius;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, cornerRadius + 1.0, 0.0);
    CGPathAddArcToPoint(path, NULL, size, 0.0, size, cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, size, cornerRadius + 1.0);
    CGPathAddArcToPoint(path, NULL, size, size, cornerRadius + 1.0, size, cornerRadius);
    CGPathAddLineToPoint(path, NULL, cornerRadius, size);
    CGPathAddArcToPoint(path, NULL, 0.0, size, 0.0, cornerRadius + 1.0, cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0.0, cornerRadius);
    CGPathAddArcToPoint(path, NULL, 0.0, 0.0, cornerRadius, 0.0, cornerRadius);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:cornerRadius topCapHeight:cornerRadius];
}


+ (UIImage *)cleverIconWithSize:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // the Clever C
    CGPathRef cleverC = CGPathFromSVGPathString(@"d=\"M10.559,20.7 C4.5,20.7 0,16.307 0,10.755 L0,10.7 C0,5.203 4.412,0.7 10.735,0.7 C14.617,0.7 16.941,1.916 18.853,3.683 L15.97,6.805 C14.382,5.451 12.764,4.623 10.705,4.623 C7.234,4.623 4.734,7.33 4.734,10.645 L4.734,10.7 C4.734,14.014 7.175,16.778 10.705,16.778 C13.058,16.778 14.499,15.893 16.116,14.512 L19,17.247 C16.883,19.374 14.529,20.7 10.559,20.7 Z\"");
    
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(14, 16);
    cleverC = CGPathCreateCopyByTransformingPath(cleverC, &moveTransform);
    
    CGContextAddRect(context, CGRectMake(46.0, 8.0, 0.5, size.height - 16.0));
    CGContextAddPath(context, cleverC);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    CGPathRelease(cleverC);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)textForButton:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // "Login with Clever"
    CGPathRef cleverText = CGPathFromSVGPathString(@"d=\"M43.923,7.019h-2.86v13.343h8.502v-2.501h-5.642V7.019z M55.684,10.459c-3.181,0-5.101,2.32-5.101,5.061s1.92,5.082,5.101,5.082c3.201,0,5.121-2.341,5.121-5.082S58.885,10.459,55.684,10.459z M55.684,18.34c-1.58,0-2.46-1.299-2.46-2.82c0-1.5,0.88-2.801,2.46-2.801c1.601,0,2.48,1.3,2.48,2.801C58.165,17.042,57.285,18.34,55.684,18.34z M69.345,11.94c-0.78-1-1.84-1.48-3.001-1.48c-2.44,0-4.261,1.76-4.261,4.921c0,3.221,1.86,4.901,4.261,4.901c1.201,0,2.241-0.541,3.001-1.5v0.939c0,1.961-1.46,2.48-2.681,2.48c-1.2,0-2.241-0.34-3.021-1.18l-1.141,1.82c1.221,1.061,2.521,1.439,4.161,1.439c2.38,0,5.221-0.899,5.221-4.561v-9.022h-2.541V11.94z M69.345,16.941c-0.44,0.62-1.36,1.101-2.181,1.101c-1.46,0-2.46-1-2.46-2.661c0-1.66,1-2.661,2.46-2.661c0.82,0,1.741,0.46,2.181,1.081V16.941zM80.803,6.639c-0.82,0-1.5,0.66-1.5,1.5c0,0.84,0.68,1.52,1.5,1.52c0.84,0,1.52-0.68,1.52-1.52C82.323,7.299,81.643,6.639,80.803,6.639z M79.543,20.362h2.541v-9.663h-2.541V20.362z M90.524,10.459c-1.561,0-2.761,0.76-3.381,1.48v-1.241h-2.541v9.663h2.541V13.84c0.44-0.561,1.2-1.121,2.201-1.121c1.08,0,1.78,0.46,1.78,1.8v5.842h2.561V13.54C93.685,11.66,92.665,10.459,90.524,10.459z M111.004,17.201l-2.12-6.501h-2.261l-2.121,6.501l-1.8-6.501h-2.641l2.94,9.663h2.721l2.04-6.582l2.041,6.582h2.721l2.94-9.663h-2.66L111.004,17.201z M116.722,20.362h2.54v-9.663h-2.54V20.362z M117.982,6.639c-0.819,0-1.5,0.66-1.5,1.5c0,0.84,0.681,1.52,1.5,1.52c0.841,0,1.521-0.68,1.521-1.52C119.502,7.299,118.823,6.639,117.982,6.639z M125.723,18.34c-0.561,0-0.881-0.459-0.881-1.08v-4.34h1.961v-2.221h-1.961V8.059h-2.54v2.641h-1.601v2.221h1.601v5.021c0,1.74,0.939,2.661,2.721,2.661c1.06,0,1.74-0.28,2.12-0.621l-0.54-1.939C126.462,18.202,126.103,18.34,125.723,18.34z M134.483,10.459c-1.58,0-2.761,0.76-3.381,1.48V7.019h-2.561v13.343h2.561V13.84c0.42-0.561,1.2-1.121,2.201-1.121c1.08,0,1.78,0.42,1.78,1.76v5.882h2.54V13.5C137.624,11.62,136.604,10.459,134.483,10.459zM151.823,9.319c1.36,0,2.561,0.86,3.12,1.94l2.441-1.2c-0.94-1.68-2.641-3.26-5.562-3.26c-4.021,0-7.122,2.78-7.122,6.901c0,4.101,3.102,6.902,7.122,6.902c2.921,0,4.621-1.621,5.562-3.281l-2.441-1.18c-0.56,1.081-1.76,1.94-3.12,1.94c-2.44,0-4.201-1.86-4.201-4.38S149.382,9.319,151.823,9.319z M159.021,20.362h2.541V7.019h-2.541V20.362z M168.462,10.459c-2.921,0-5.001,2.26-5.001,5.061c0,3.101,2.22,5.082,5.16,5.082c1.501,0,3.021-0.461,3.981-1.341l-1.141-1.681c-0.62,0.601-1.74,0.94-2.561,0.94c-1.64,0-2.601-0.979-2.78-2.16h7.182v-0.6C173.303,12.62,171.363,10.459,168.462,10.459zM166.101,14.6c0.101-0.96,0.78-2.06,2.361-2.06c1.68,0,2.32,1.14,2.4,2.06H166.101z M179.001,17.42l-2.521-6.721h-2.721l3.881,9.663h2.741l3.881-9.663h-2.721L179.001,17.42z M189.782,10.459c-2.921,0-5.001,2.26-5.001,5.061c0,3.101,2.22,5.082,5.161,5.082c1.5,0,3.021-0.461,3.98-1.341l-1.141-1.681c-0.62,0.601-1.74,0.94-2.561,0.94c-1.64,0-2.6-0.979-2.78-2.16h7.182v-0.6C194.623,12.62,192.682,10.459,189.782,10.459z M187.421,14.6c0.1-0.96,0.78-2.06,2.36-2.06c1.681,0,2.32,1.14,2.4,2.06H187.421z M199.001,12v-1.3h-2.541v9.663h2.541V13.98c0.42-0.62,1.54-1.1,2.38-1.1c0.301,0,0.521,0.02,0.7,0.06v-2.48C200.881,10.459,199.702,11.16,199.001,12z\"");

    CGFloat moveX = ((size.width - CleverLoginButtonBaseWidth) / 2) + 20;
    CGFloat moveY = 12;
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(moveX, moveY);
    cleverText = CGPathCreateCopyByTransformingPath(cleverText, &moveTransform);
    
    CGContextAddPath(context, cleverText);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    CGPathRelease(cleverText);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
