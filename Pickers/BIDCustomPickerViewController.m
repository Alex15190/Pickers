//
//  BIDCustomPickerViewController.m
//  Pickers
//
//  Created by Alex Chekodanov on 21.08.2018.
//  Copyright © 2018 MERA. All rights reserved.
//

#import "BIDCustomPickerViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BIDCustomPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *winLable;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation BIDCustomPickerViewController{
    SystemSoundID winSoundID;
    SystemSoundID crunchSoundID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.images =@[[UIImage imageNamed:@"seven"], [UIImage imageNamed:@"bar"], [UIImage imageNamed:@"crown"], [UIImage imageNamed:@"cherry"], [UIImage imageNamed:@"lemon"], [UIImage imageNamed:@"apple"]];
    srand(time(NULL));
}

- (void)showButton
{
    self.button.hidden = NO;
}

- (void)playWinSound
{
    if (winSoundID == 0)
    {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &winSoundID);
    }
    AudioServicesPlaySystemSound(winSoundID);
    self.winLable.text = @"WINNING!";
    [self performSelector:@selector(showButton) withObject:nil afterDelay:1.5];
}

- (IBAction)spin:(id)sender
{
    BOOL win = NO;
    int numInRow = 1;
    int lastVal = -1;
    for (int i = 0; i < 5; i++) {
        int newValue = rand() % [self.images count];
        
        if (newValue == lastVal)
            numInRow++;
        else
            numInRow = 1;
        lastVal = newValue;
        
        [self.picker selectRow:newValue inComponent:i animated:YES];
        [self.picker reloadComponent:i];
        if (numInRow >= 3)
        {
            win = YES;
        }
    }
    if (crunchSoundID == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"crunch" ofType:@"wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &crunchSoundID);
    }
    AudioServicesPlaySystemSound(crunchSoundID);
    
    if(win)
        [self performSelector:@selector(playWinSound) withObject:nil afterDelay:.5];
    else
        [self performSelector:@selector(showButton) withObject:nil afterDelay:.5];
    self.button.hidden = YES;
    self.winLable.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.images count];
}

#pragma mark Picker Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = self.images[row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}
@end
