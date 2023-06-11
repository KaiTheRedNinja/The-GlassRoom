# The GlassRoom
A macOS Native Google Classroom Client

## Features
 - [x] Basic google classroom parity
   - [x] Loading courses
   - [x] Loading posts
   - [x] Viewing submissions
   - [x] Viewing class members
 - [ ] Advanced google classroom parity
   - [x] Post creation
   - [x] View student submissions
   - [ ] Submit in-app (Not possible rn due to API restrictions)
   - [ ] Grading
 - User Speed Improvements/Conveniences
   - [x] Practically instant loading (via post caching)
   - [x] Offline mode (same reason)
   - [x] Quick open/search (so you can open courses without having to hunt for them with your mouse. Just search by name.)
   - [x] Sorting by post type (eg. only announcements, assignements, or materials)
   - [x] Viewing multiple courses' posts at once (bit buggy rn tho :P)
   - [ ] Post tagging
 - Customisability
   - [x] Client-side grouping courses into folders
   - [x] Client-side archiving of courses
   - [x] Custom course colors/icons
   - [x] Renaming your classes using regex (eg. removing redundant "2023"s)
   - [x] Date groups for posts (eg. "Last month", "This year" in that image)
 - Accessibility
   - [x] Bionic reading (bolds the first few characters of a word, helps adhd people focus when reading)

## Speed comparisons

|          Category         | Google Classroom Web |   GlassRoom (cached)   | GlassRoom (non-cached) |
|---------------------------|----------------------|------------------------|------------------------|
|   Launching website/app   |         4.68s        |           N/A          |          0.99s         |
|      Loading courses      |         3.50s        |          0.00s         |          1.48s         |
|       Loading posts       |         2.80s        |          0.14s         |          1.18s         |
| Loading post's submission |         0.90s        |          0.13s         |          0.31s         |

## Images
TODO
- Standard view
- Search
- Submissions
- Settings

## Building
#### NOTE: This MAY be outdated

Prerequisite: You have a google developer project with an API key capable of utilising Google Classroom and Drive APIs
1. Add your own `The-GlassRoom-Info.plist` file, in this format:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.[YOUR_KEY_HERE]</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
```
2. Create `Secrets (Sensitive).swift`, extend the `Secrets` enum and override `static func getGoogleClientID() -> String` to return your API key
3. Change the bundle identifier and team in the xcodeproj to your own
