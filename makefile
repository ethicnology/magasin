.PHONY: all setup clean dependencies runner drift-migrations ios-pod-update fvm-check

fvm-install:
	@echo "🔍 Installing FVM"
	@curl -fsSL https://fvm.app/install.sh | bash
	@echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH

fvm-check: 
	@echo "🔍 Checking FVM"
	@if ! command -v fvm >/dev/null 2>&1; then \
		echo "❌ FVM is not installed. Please install FVM first:"; \
		exit 1; \
	fi
	@echo "✅ FVM is installed"
	@fvm install

init: fvm-install clean dependencies runner

refresh: fvm-check clean dependencies runner ios-pod-update
	@echo "🚀 Ready to go!"

clean:
	@echo "🧹 Clean and remove pubspec.lock and ios/Podfile.lock"
	@fvm flutter clean && rm -f pubspec.lock && rm -f ios/Podfile.lock

dependencies:
	@echo "🏃 Fetch dependencies"
	@fvm flutter pub get

runner:
	@echo "🏗️ Build runner for dart_mappable"
	@fvm dart run build_runner build --delete-conflicting-outputs

drift:
	@echo "🔄 Create schema and sum migrations"
	fvm dart run drift_dev make-migrations

ios-pod-update:
	@echo " Fetching dependencies"
	@fvm flutter precache --ios
	@cd ios && pod install --repo-update && cd -