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
    MenuDataModel *dataModel = [[MenuDataModel alloc]initWithURL:[NSURL URLWithString:@"http://reddit.com/reddits.json"]];
    menuContents = [dataModel subredditNames];
    self.navigationItem.title = @"subreddits";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [menuContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"subredditCell"];
    cell.subredditLabel.text = [menuContents objectAtIndex:indexPath.row];
    return cell;
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
        NSLog(@"%@", [menuContents objectAtIndex:currentIndex]);
        SubredditTableViewController *subredditViewController = destinationNavController.viewControllers[0];
        subredditViewController.subredditTitle = [menuContents objectAtIndex:currentIndex];
        subredditViewController.subredditURL = [self constructURLFromTitle:[menuContents objectAtIndex:currentIndex]];
        subredditViewController.setFromSegue = YES;
    }
}


-(NSURL *) constructURLFromTitle: (NSString *) title {
    // Front page needs to be constructed seperately since it's no API Item
    if([title isEqualToString:@"front"]) {
        return [NSURL URLWithString:@"http://reddit.com/.json"];
    }
    NSMutableString *construct = [NSMutableString stringWithString:@"http://reddit.com/r/"];
    [construct appendString:title];
    [construct appendString:@".json"];
    return [NSURL URLWithString:construct];
}

@end
