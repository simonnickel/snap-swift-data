// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "snap-swift-data",
	platforms: [
		.iOS(.v18), .macOS(.v15)
	],
    products: [
        .library(
            name: "SnapSwiftData",
            targets: ["SnapSwiftData"]
		),
    ],
    targets: [
        .target(
            name: "SnapSwiftData"
		),
    ],
)
