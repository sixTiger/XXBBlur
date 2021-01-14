//
//  ViewController.m
//  XXBBlurDemo
//
//  Created by xiaobing5 on 2021/1/8.
//

#import "ViewController.h"
#import "XXBBlurEffectView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(nonatomic, weak) XXBBlurEffectView  *blurEffectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    XXBBlurEffectView  *blurEffectView = [[XXBBlurEffectView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:blurEffectView];
    _blurEffectView = blurEffectView;
    [self.view bringSubviewToFront:self.slider];
    self.slider.value = self.blurEffectView.inputRadius;
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    NSLog(@"XXB | %@", @(sender.value));
    [self.blurEffectView setInputRadius:sender.value];
    [self.blurEffectView setTintColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]];
}


@end
