dev:
	flutter run

release-apk:
	flutter build apk --release

release-aab:
	flutter build appbundle --release

all-in:
	flutter build apk --release && flutter build appbundle --release

clean:
	flutter clean