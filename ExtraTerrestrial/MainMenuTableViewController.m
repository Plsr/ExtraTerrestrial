//
//  MainMenuTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 24/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "MainMenuTableViewController.h"

@interface MainMenuTableViewController ()
{
    NSArray *menuContents;
}
@end

@implementation MainMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Data Model
    MenuDataModel *dataModel = [[MenuDataModel alloc]initWithURL:[NSURL URLWithString:@"http://reddit.com/reddits.json"]];
    menuContents = [dataModel subredditNames];
    
    self.navigationItem.title = @"subreddits";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
 *  For now, there is only one section in the master view controller.
 *  Note sure if settings etc will have a seperate section later.
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/*
 *  Rows in the single section equals the number of items to be dsiplayed.
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [menuContents count];
}

/*
 *  Setting the content of each cell. Since we only have one label per cell,
 *  it's pretty straight forward.
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"subredditCell"];
    cell.subredditLabel.text = [menuContents objectAtIndex:indexPath.row];
    return cell;
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier]isEqualToString:@"showSubredditOverview"]) {
        UINavigationController *destinationNavController = segue.destinationViewController;
        NSInteger currentIndex = [[self.tableView indexPathForSelectedRow] row];
        SubredditTableViewController *subredditViewController = destinationNavController.viewControllers[0];
        
        // Send data to destination view controller
        subredditViewController.subredditTitle = [menuContents objectAtIndex:currentIndex];
        subredditViewController.subredditURL = [self constructURLFromTitle:[menuContents objectAtIndex:currentIndex]];
        subredditViewController.setFromSegue = YES;
    }
}


/**
 *  Constructs a valid NSURL for an API-Call from the ttitle of a subreddit.
 *
 *  @param title The title of the subreddit as NSString
 *
 *  @return valid NSURL to make an API-Call with.
 *
 */
-(NSURL *) constructURLFromTitle: (NSString *) title {
    // Front page needs to be constructed seperately since it's no API item
    if([title isEqualToString:@"front"]) {
        return [NSURL URLWithString:@"http://reddit.com/.json"];
    }
    NSMutableString *construct = [NSMutableString stringWithString:@"http://reddit.com/r/"];
    [construct appendString:title];
    [construct appendString:@".json"];
    return [NSURL URLWithString:construct];
}

@end
