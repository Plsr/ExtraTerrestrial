//
//  SelfPostTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 13/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SelfPostTableViewController.h"

static NSString * const kContentCellIdentifier = @"contentCell";
static NSString * const kCommentCellIdentifier = @"commentCell";
static NSString * const kContinueCellIdentifier = @"continueCell";

@interface SelfPostTableViewController (){
    NSArray *commentsData;
    CGFloat webViewHeight;
}

@end

@implementation SelfPostTableViewController

// TODO: Add activity indicator until data is loaded, load data elesewhere
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 144.0;
    self.postURLString = [self.postData objectForKey:@"permalink"];
    NSURL *singlePostURL = [self urlFromPermalink:self.postURLString];
    SinglePostDataModel *dataModel = [[SinglePostDataModel alloc] initWithURL:singlePostURL];
    commentsData = [NSArray arrayWithArray:[dataModel topLevelComments]];
    //NSLog(@"%@", commentsData);
    
    
    //SinglePostAPICall *apiCall = [[SinglePostAPICall alloc] initWithURL:singlePostURL];
    //NSLog(@"%@", apiCall.apiCallReturns);
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
        // Quickfix for last element of array, which only contains the links to the "load more" comments
        // TODO: Do somethinge useful with the "more comments" links
        
        return [commentsData count] - 1;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // First section, only has one row for the content
    if (indexPath.section == 0) {
        ContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier];
        [self configureContentCell:contentCell atIndexPath:indexPath];
        return contentCell;
    } else {
        if ([[[commentsData objectAtIndex:indexPath.row] objectForKey:@"isMoreIndicator"] boolValue]) {
            //TODO: Own function
            ContinueTableViewCell *continueCell = [tableView dequeueReusableCellWithIdentifier:kContinueCellIdentifier];
            NSInteger level = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"commentLevel"] integerValue];
            continueCell.continueLabelLeftPadding.constant = 20 * level;
            return continueCell;
        } else {
            CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
            [self configureCommentCell:commentCell atIndexPath:indexPath];
            return commentCell;
        }

    }
    
    
}

//TODO: do I need the IndexPath here?
- (void)configureContentCell:(ContentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Meta
    cell.titleLabel.text = [self.postData objectForKey:@"title"];
    cell.authorLabel.text = [self.postData objectForKey:@"author"];
    cell.scoreLabel.text = [[self.postData objectForKey:@"score"] stringValue];
    cell.subredditLabel.text = [self.postData objectForKey:@"subreddit"];
    cell.timeLabel.text = [self timeSincePosted:[[self.postData objectForKey:@"created_utc"] doubleValue]];
    
    // Content
    if ([[self.postData objectForKey:@"selftext"] length]) {
        NSString *htmlSelftext = [self createStringForWebView:[self.postData objectForKey:@"selftext"]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlSelftext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.contentTextView.attributedText = attributedString;
        [cell.contentTextView setFont:[UIFont systemFontOfSize:17]];
    } else {
        // No body content, remove UITextView.
        // TODO: Not working clean, extra cell?
        [cell.contentTextView removeFromSuperview];
    }
    
    
    
    // Update constraints after elements are filled with content.
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}

-(void)configureCommentCell: (CommentTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.authorLabel.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"author"];
    cell.scoreLabel.text = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"score"] stringValue];
    cell.timeLabel.text = @"4 hours ago"; //TODO: Placeholder, replace!
    cell.bodyTextView.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"body"];
    NSInteger level = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"commentLevel"] integerValue];
    cell.textViewLeftPadding.constant = 20 * level;
    cell.authorLabelLeftPadding.constant = 20 * level;
    [cell.bodyTextView setNeedsUpdateConstraints];
    
    /*
    // Content
    //create the string
    NSString *sysFontName = @"Helvetica Neue";
    NSString *sysFontSize = @"15pt";
    NSMutableString *html = [NSMutableString stringWithFormat: @"<html><head><title></title></head><body style=\"background:transparent;font-family:%@;font-size:%@; \">",sysFontName, sysFontSize];
    //continue building the string
    
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[[[commentsData objectAtIndex:indexPath.row] objectForKey:@"body_html"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *markdownString = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"body"];
    [html appendString:[MMMarkdown HTMLStringWithMarkdown:markdownString error:nil]];
    [html appendString:@"</body></html>"];
    
    
    //pass the string to the webview
    //sizingCell.bodyWebView.delegate = sizingCell;
    cell.bodyWebView.delegate = self;
    [cell.bodyWebView loadHTMLString:[html description] baseURL:nil];
    cell.bodyWebView.scrollView.scrollEnabled = NO;
    */
    
    [cell updateConstraints];
    [cell layoutSubviews];
}







/*

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CommentTableViewCell *sizingCell = nil;
    //  GCD, see https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  This part is only ran once
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    });
    sizingCell.authorLabel.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"author"];
    sizingCell.scoreLabel.text = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"score"] stringValue];
    sizingCell.timeLabel.text = @"4 hours ago"; //TODO: Placeholder, replace!
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = (size.height) + webViewHeight;
    NSLog(@"Cell height: %f", height);
    return height + 1.0f;
    
} */



// None of the Table Cells are selectable
// TODO: Disable later for replys of comments etc.
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return nil;
}



#pragma mark - Helper methods for data source

// TODO: Move to Model
-(NSURL *) urlFromPermalink: (NSString *) permalink {
    NSString *redditURL = @"http://reddit.com";
    NSString *json = @".json";
    NSString *construct = [[redditURL stringByAppendingString:permalink] stringByAppendingString:json];
    NSURL *validPermalinkURL = [NSURL URLWithString:construct];
    return validPermalinkURL;
}

// TODO: rename function
// TODO: Move to Model
-(NSString *) createStringForWebView: (NSString *) body {
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    NSError *error;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:body error:&error];
    [html appendString:htmlString];
    [html appendString:@"</body></html>"];
    //NSLog(@"%@", [html description]);
    return [html description];
}

-(NSString *) decodeMarkdownForString: (NSString *) string {
    NSError *error;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:string error:&error];
    
    if (!error) {
        return htmlString;
    } else {
        return @"error";
    }
}


-(NSString *) timeSincePosted: (double) timestamp {
    NSTimeInterval _interval = timestamp;
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSTimeInterval secondsPassed = [postDate timeIntervalSinceNow];
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSString *result = [timeIntervalFormatter stringForTimeInterval:secondsPassed];
   
    return result;
}


#pragma mark - Section headers

// Set the title for the header in the given section.
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"Comments • %lu", (unsigned long)[commentsData count]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 40.0f;
    }
}


//TODO: Clean up
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 10, 300, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:16];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [headerView addSubview:myLabel];
    
    return headerView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
