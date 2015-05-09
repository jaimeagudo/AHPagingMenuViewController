AHPagingMenuViewController
====================

AHPagingMenuViewController 1.0. Menu Paging like UINavigationController used in Tinder! Highly customizable

## Demo

![AHPagingMenuViewController](https://github.com/andrehenrique92/AHPagingMenuViewController/blob/master/assets/icon1.gif)
![AHPagingMenuViewController](https://github.com/andrehenrique92/AHPagingMenuViewController/blob/master/assets/icon2.gif)
 

##Installation

1. Using [CocoaPods](http://cocoapods.org/). Easy, easy! Add this line to your Podfile:

```ruby
pod 'AHPagingMenuViewController'
```

So... Run this command:

```ruby
pod install
```

2. Add the AHPagingMenuViewController Folder into your project.


## How Use

Very easy! Just import the file

```objc
#import "AHPagingMenuViewController"
```
So, alloc with your controllers and titles (NSString or UIImage)

```objc
AHPagingMenuViewController *AHController = [[AHPagingMenuViewController alloc] initWithControllers: @[v1,v2,v3] andMenuItens:@[[UIImage imageNamed:@"photo"],[UIImage imageNamed:@"heart", @"Title"]];
```

Easy, easy! See more in Demo!

## Licence

[MIT](https://github.com/pixyzehn/MediumMenu/blob/master/LICENSE)

## Author

[andrehenrique92](https://github.com/andrehenrique92)
[site](http://andrehenrique.me)
Problems ? Suggestions? Send to me! andre.henrique@me.com
Thank you! =D
