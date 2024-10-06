.PHONY: format
format:
	xcrun --sdk macosx swift-format swift-format -p -r -i .

.PHONY: build_docc
build_docc:
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--output-path ./docs \
		--disable-indexing \
		--symbol-graph-minimum-access-level internal \
		--include-extended-types \
		--enable-experimental-combined-documentation \
		--target IAPClient \
		--target IAPCore \
		--target IAPInterface \
		--target IAPModel \
		--target IAPView \
		--transform-for-static-hosting \
		--hosting-base-path IAPViewer

