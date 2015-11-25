# Loop News

## Setting Up Your Workspace

Loop News is built in Swift, but uses Cocoapods for dependencies and has dependencies on Objective-C libraries. Therefore, a bridging header has been setup.

First, clone the repository to your local disk. There are currently two branches-- master and develop. Master should contain the stable code and you should either branch off of the "develop" branch or work directly on top of it.

Finally, use Cocoapods to install the dependencies and open the .xcworkspace folder with Xcode. Do *not* open the xcproject folder.

```
git clone git@github.com:andrewmunsell/loop-news.git
cd loop-news
git checkout develop
pod install
open Loop News.xcworkspace
```
