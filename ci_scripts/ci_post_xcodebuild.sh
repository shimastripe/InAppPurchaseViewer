#!/bin/zsh
set -ex

if [[ -n $CI_TAG ]]; then
  echo "This build started from a release tag: $CI_TAG"

  hdiutil create -srcfolder $CI_DEVELOPER_ID_SIGNED_APP_PATH/InAppPurchaseViewer.app -volname InAppPurchaseViewer InAppPurchaseViewer_$CI_TAG.dmg

  brew install gh
  gh release upload $CI_TAG InAppPurchaseViewer_$CI_TAG.dmg
fi
