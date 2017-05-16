//
//  CTMainViewController.m
//  CardTilt
//
//  Created by Brian Broom on 8/16/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "CTMainViewController.h"
#import "CTCardCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CTMainViewController ()

@property (strong, nonatomic) NSArray *members;
@property (assign, nonatomic) CATransform3D initialTransformation;
@property (nonatomic, strong) NSMutableSet *shownIndexes;


@end

@implementation CTMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  NSError *error;
  NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TeamMembers" ofType:@"json"]];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  
  self.members = json[@"team"];
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
  
  CGFloat rotationAngleDegrees = -15;
  CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
  CGPoint offsetPositioning = CGPointMake(-20, -20);
  
  CATransform3D transform = CATransform3DIdentity;
  transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
  transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
  _initialTransformation = transform;
  
  _shownIndexes = [NSMutableSet set];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [self.members count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
  NSString *aboutText = _members[indexPath.row][@"about"];
  NSString *newlineString = @"\n";
  NSString *newAboutText = [aboutText stringByReplacingOccurrencesOfString:@"\\n" withString:newlineString];
  
  
//  CGSize aboutSize = [newAboutText sizeWithFont:font constrainedToSize:CGSizeMake(268, 4000)];
  
  // if deployment target is iOS7 and you want to get rid of the warning above
  // comment the line above and uncomment the following section
  
  // ios 7 only
  CGRect boundingRect = [newAboutText boundingRectWithSize:CGSizeMake(268, 4000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
  
  CGSize aboutSize = boundingRect.size;
  // end ios7 only
  
  
  return (280-15+aboutSize.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Card";
  CTCardCell *cell = (CTCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  // Configure the cell...
  
  [cell setupWithDictionary:[self.members objectAtIndex:indexPath.row]];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (![self.shownIndexes containsObject:indexPath]) {
    [self.shownIndexes addObject:indexPath];
    
    UIView *card = [(CTCardCell* )cell mainView];
    
    card.layer.transform = self.initialTransformation;
    card.layer.opacity = 0.8;
    
    [UIView animateWithDuration:0.4 animations:^{
      card.layer.transform = CATransform3DIdentity;
      card.layer.opacity = 1;
    }];
  }
}

@end
