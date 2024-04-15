# SnapSwiftData

SnapSwiftData is a library to extend SwiftData with access to CoreData objects.

SwiftData is build on CoreData, but does not completely cover its functionality. SnapSwiftData tries to fill some gaps, so you do not need to create a duplicated CoreData stack.

The package is heavily inspired by https://github.com/fatbobman/SwiftDataKit


## Features

- Extensions
-- ModelContext.existingModel(for:)
-- NSManagedObjectID+PersistentIdentifier (by https://useyourloaf.com/blog/swiftdata-fetching-an-existing-object/)
- Persistent History Tracking (https://fatbobman.com/en/posts/persistent-history-tracking-in-swiftdata/)
- DataManager: A wrapper around ModelContainer with Persistent History Tracking.


## Disclaimer

The implementation relies on current CoreData / SwiftData implementation details. This means it might break with future versions of SwiftData. Please use carefully.

This should not be necessary at all and supported by SwiftData (FB13577205).


## Good to know

Add to launch arguments to silence CloudKit logs (see https://useyourloaf.com/blog/disabling-core-data-cloudkit-logging/):

`-com.apple.CoreData.Logging.stderr 0`
