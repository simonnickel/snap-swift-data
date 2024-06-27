<!-- Copy badges from SPI -->
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-swift-data%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/simonnickel/snap-swift-data)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-swift-data%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/simonnickel/snap-swift-data) 

> This package is part of the [SNAP](https://github.com/simonnickel/snap-abstract) suite.



// TODO: Checkout WWDC24 changes to SwiftData regarding history tracking.



# SnapSwiftData

This package improves interoperability between SwiftData and CoreData. It provides SwiftData with access to CoreData objects and Persistent History Tracking.

SwiftData is build on CoreData, but does not completely cover its functionality. SnapSwiftData tries to fill some gaps, so you do not need to create a duplicated CoreData stack.

The package is heavily inspired by https://github.com/fatbobman/SwiftDataKit

[![Documentation][documentation badge]][documentation] 

[documentation]: https://swiftpackageindex.com/simonnickel/snap-swift-data/main/documentation/snapswiftdata
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue


## Features

- Extensions
-- ModelContext.existingModel(for:)
-- NSManagedObjectID+PersistentIdentifier (by https://useyourloaf.com/blog/swiftdata-fetching-an-existing-object/)
- Persistent History Tracking (https://fatbobman.com/en/posts/persistent-history-tracking-in-swiftdata/)
- DataManager: A wrapper around ModelContainer with Persistent History Tracking.


## Disclaimer

The implementation relies on current CoreData / SwiftData implementation details. This means it might break with future versions of SwiftData. Please use carefully.

Nothing in this package should not be necessary at all and be supported by SwiftData (FB13577205).


## Good to know

Add to launch arguments to silence CloudKit logs (see https://useyourloaf.com/blog/disabling-core-data-cloudkit-logging/):

`-com.apple.CoreData.Logging.stderr 0`
