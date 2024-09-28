#!/bin/zsh
set -ex

defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# [Workaround]: Fallback swift 5 mode
sed -i '' 's/\.v6/\.v5/g' /Volumes/workspace/repository/Package.swift
sed -i '' 's/SWIFT_VERSION = 6.0/SWIFT_VERSION = 5.0/g' /Volumes/workspace/repository/App/InAppPurchaseViewer/InAppPurchaseViewer.xcodeproj/project.pbxproj
