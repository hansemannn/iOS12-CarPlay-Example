# iOS 12 CarPlay Example

An example of using the CarPlay framework in iOS 12 and later.

## Summary

This sample project uses the `CarPlay` framework to start a simple navigation session
from your existing project. It utilizes the `CPApplicationDelegate` to connect to your
car, `CPInterfaceController` to attach your view controller and `CPMapTemplate` to show
and example template as part of the "root template" of the controller.

## Notes

Some general hints I have noticed so far:

- CarPlay works primarily in "templates", not "views" or "controllers". It means that you
cannot design your CarPlay screen like you would design your iOS app, but you need to provide
information that is then displayed in the related template.
- The connection is done via the `CPApplicationDelegate` delegate that inherits from the
`UIApplicationDelegate`, so you usually handle it as part of your main app-delegate class.
- Once connected, you can push and pop templates like you would do with view controllers
- Data can be used by shared frameworks, networking or general persistence layer. In this
example, I simply persist an encoded dictionary of latitude and longitude pairs in the
`UserDefaults` and grab it for my CarPlay connection once ready.

## More?

Let me know if you have further questions! As of for now, this is a tiny example to get your
head around the whole framework, but it can be extended to show other template types like
lists, grids and UI elements like alerts and notifications.


## Author

Hans Knöchel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

## License

MIT

## Contributing

Code contributions are greatly appreciated, please submit a new [Pull-Request](https://github.com/hansemannn/iOS12-CarPlay-Example/pull/new/master)!
