# iOS Protocol Oriented Networking in Swift

When one of our projects transistioned to another engineer, we noticed that everyone's networking code was different. We didn't like that everytime someone took over a project, they had to "learn" that network layer. To solve this, the iOS Engineers decided that we should all use the same networking setup to solve these headaches, thus we looked into Protocol Oriented Networking.


### Dependencies
------

We ended up going with [Alamofire](https://github.com/Alamofire/Alamofire) instead of `URLSession` for a few reasons. Alamofire is asynchronous by nature, has session management, reduces boilerplate code, and is very easy to use.


### Blog
------

You can go to our [Blog](https://staging.teeps.org/blog/2017/02/07/27-protocol-oriented-networking-in-swift) to read more.