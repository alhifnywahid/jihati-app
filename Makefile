dev:
	flutter run

release-apk:
	flutter build apk --release

release-aab:
	flutter build appbundle --release

distribute:
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app 1:462694081045:android:93db9f085499623302641c --groups "rua" --release-notes "+ homepage, prayer times and more" 

all-in:
	flutter build apk --release && flutter build appbundle --release

clean:
	flutter clean