//
//  XXBBlurEffectView.m
//  XXBBlurDemo
//
//  Created by xiaobing5 on 2021/1/8.
//

#import "XXBBlurEffectView.h"

@interface NSObject (blur)
@property(nonatomic, strong) NSMutableDictionary    *requestedValues;

- (NSObject *)valueForKey:(NSString *)key withFilterType:(NSString *)filterTypeString;
@end

@implementation NSObject (blur)

- (void)setRequestedValues:(NSDictionary *)requestedValues {
    [self setValue:requestedValues forKeyPath:@"requestedValues"];
}

- (NSDictionary *)requestedValues {
    return [self valueForKeyPath:@"requestedValues"];
}

- (NSObject *)valueForKey:(NSString *)key withFilterType:(NSString *)filterTypeString {
    __block NSObject *tagFilter = nil;
    NSArray *filters = [self valueForKeyPath:key];
    [filters enumerateObjectsUsingBlock:^(NSObject *filter, NSUInteger idx, BOOL *stop) {
        NSString *currentFilterTypeString = [filter valueForKeyPath:@"filterType"];
        if ([currentFilterTypeString isEqualToString:filterTypeString]) {
            tagFilter = filter;
            *stop = YES;
        }
    }];
    return tagFilter;
}
@end

@interface XXBBlurEffectView()

@property(nonatomic, strong) UIView         *backdropView;
@property(nonatomic, strong) UIView         *overlayView;
@property(nonatomic, strong) NSObject       *gaussianBlur;
@property(nonatomic, strong) NSObject       *sourceOver;
@property(nonatomic, strong) UIBlurEffect   *blurEffect;
@end

@implementation XXBBlurEffectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareForChanges];
        [self applyChanges];
    }
    return self;
}

- (void)setInputRadius:(float)inputRadius {
    [self prepareForChanges];
    NSMutableDictionary *requestedValues = [self.gaussianBlur.requestedValues mutableCopy];
    requestedValues[@"inputRadius"] = @(inputRadius);
    self.gaussianBlur.requestedValues = requestedValues;
    [self applyChanges];
}

- (float)inputRadius {
    NSDictionary *requestedValues = self.gaussianBlur.requestedValues;
    return [requestedValues[@"inputRadius"] floatValue];
}

- (void)setTintColor:(UIColor *)tintColor {
    [self prepareForChanges];
    [self.sourceOver setValue:tintColor forKeyPath:@"color"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.sourceOver performSelector:@selector(applyRequestedEffectToView:)];
#pragma clang diagnostic pop
    [self applyChanges];
}

- (UIColor *)tintColor {
    return [self.sourceOver valueForKeyPath:@"color"];
}
#pragma mark -

- (UIView *)backdropView {
    return [self subViewOfClass:NSClassFromString(@"_UIVisualEffectBackdropView")];
}

- (UIView *)overlayView {
    return [self subViewOfClass:NSClassFromString(@"_UIVisualEffectSubview")];
}

- (NSObject *)gaussianBlur {
    return [self.backdropView valueForKey:@"filters" withFilterType:@"gaussianBlur"];
}

- (NSObject *)sourceOver {
    return [self.overlayView valueForKey:@"viewEffects" withFilterType:@"sourceOver"];
}

- (UIView *)subViewOfClass:(Class)classType {
    __block UIView *tagView = nil;
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * stop) {
        if ([subview isKindOfClass:classType]) {
            tagView = subview;
            *stop = YES;
        }
    }];
    return tagView;
}


- (void)prepareForChanges {
    self.effect = [self blurEffect];
    [self.gaussianBlur setValue:@(1.0) forKeyPath:@"requestedScaleHint"];
}

- (void)applyChanges {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.backdropView performSelector:@selector(applyRequestedFilterEffects)];
#pragma clang diagnostic pop
}

- (UIBlurEffect *)blurEffect {
    if (_blurEffect == nil) {
        _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return _blurEffect;
}
@end
