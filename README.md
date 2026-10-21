# Political Advisory — Flutter Web Dashboard

Starter dashboard for managing campaigns, booths, events, and teams.

> This is a frontend starter with demo data. Authentication, API integration, persistence, authorization, and production analytics are not implemented.

## Requirements

- Flutter stable with web support enabled
- Git
- Chrome (optional, for `flutter run -d chrome`)

Check your setup:

```bash
flutter --version
flutter doctor
flutter devices
```

## Run locally

From this directory:

```bash
flutter pub get
flutter run -d chrome
```

Or run on a connected device:

```bash
flutter run
```

## Validate

```bash
dart format .
flutter analyze
flutter test
```

## Build the web app

```bash
flutter build web --release
```

Output is written to `build/web/`.

## Suggested Git workflow

After extracting this archive into your cloned repository:

```bash
git switch -c feature/flutter-dashboard
git status
git add .
git commit -m "feat: add Flutter political advisory dashboard"
git push -u origin feature/flutter-dashboard
```

If the remote repository has no commits yet, Git may not have a `main` branch locally. In that case, initialize and commit first, then add/push the remote as described in the project setup instructions.

## Initial modules

- Dashboard overview
- Campaigns
- Booths
- Events
- Teams
- Analytics
- Settings

The navigation is functional; modules other than the dashboard are currently clearly marked as scaffolds.
