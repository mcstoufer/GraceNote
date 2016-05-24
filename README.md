What this is
===
This workspace encompases work done by [Martin Stoufer](mcstoufer@speakeasy.net) for a coding exercise at GraceNote described at <https://github.com/gravitymobile/iOSCodingChallenge>

Installation
===
There are two CocoaPod dependencies added to this workspace.

Before you build and run the app, just do a quick
`pod install`
in the top level project directory. That will get you all ready to go.

Desgin Considerations
===
Since we are pulling images from two disperate APIs, the driving goal was to keep each loading sequence as isolated as possible and only once they are available and cached are they presented in the UI.

In review of the code, you will see healthy use of async dispatch onto various global queues. This allowed the main thread to keep the UI very responsive.
The TableViewController subclass that is used to display each decorated Twitter tweet is completely divorced from the loading of images from the APIs. Only a small view from the master UIViewController subclass has any interaction with the Twitter stream that fetches the tweets.

The rather distended OAuth regime imposed by Flickr caused some serious design shortcomings a bit late in the design game. As noted below, solutions to these have been called out in the code.

NOTES
===
* Due to the time limits of this exercise, there are a few _TODO_ comments left in the code that note obvious improvements that could be made and why. Given more time, these too can be accomplished.
* There are live key/secrets for both Twitter and Flickr in the code base. In a real app, these would be tucked away* someplace a bit less obvious. As long as this code base isn't widely distributed, I'm happy to let them be.


\* Encrypted