//
//  MyViewController.m
//  moodyfriends
//
//  Created by Kyle Langille on 2013-02-09.
//  Copyright (c) 2013 Kyle Langille. All rights reserved.
//

#import "MyViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "TweetCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MyViewController ()

@end

@implementation MyViewController{
    IBOutlet UITableView *table;
    IBOutlet UILabel *name;
    IBOutlet UIImageView *profPic;
}

@synthesize user;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[user objectForKey:@"tweets"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userCell";
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch ([[[[user objectForKey:@"tweets"] objectAtIndex:indexPath.row] objectForKey:@"sentiment"] integerValue]) {
        case -1:
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:174.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
            break;
        case 0:
            cell.contentView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:179.0f/255.0f blue:21.0f/255.0f alpha:1.0f];
            break;
        case 1:
            cell.contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:0.0f/255.0f blue:136.0f/255.0f alpha:1.0f];
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tweet.text = [[[user objectForKey:@"tweets"] objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc =[storybord instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    UIViewController *sourceViewController = self;
    UIViewController *destinationController = vc;
    
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];

    [self.view removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer1];
}

-(void)viewWillAppear:(BOOL)animated{
    [profPic setImageWithURL:[NSURL URLWithString:[user objectForKey:@"profile_url"]]
            placeholderImage:[UIImage imageNamed:@"UserPlaceHolder.pngg"]];
    name.text = [NSString stringWithFormat:@"@%@", [user objectForKey:@"name"]];
    
    CALayer * l = [profPic layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    
    // You can even add a border
    [l setBorderWidth:0.8];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
