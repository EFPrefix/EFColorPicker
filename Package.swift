// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "EFColorPicker",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(name: "EFColorPicker", targets: ["EFColorPicker"]),
    ],
    targets: [
        .target(name: "EFColorPicker", path: "EFColorPicker"),
    ]
)
