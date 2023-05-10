# RAWGExplorer

The application is written according to Apple's MVC design pattern with user interface mostly designed using xib files. Xib files offer simpler navigation
and better source control compatibility than storyboards while still benefiting from XCode's powerful UI editor.  
Alongside MVC, singleton design pattern was used to create networking and settings managers. This allows every part of the app to easily access those 
functionalities while keeping the code clean.  
Comuncation between view controllers has been achieved using the delegate pattern as it is a simple and elegant solution.
