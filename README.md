# The GlassRoom
A macOS Native Google Classroom Client

## Pages
 - [x] Cache
 - [x] Classroom stuff view (3 way split, similar to mail app)
 - [x] Aggregate view
 - [x] Command Palette/go-to
 - [x] Course Grouping
 - [x] Course Archiving
 - [x] Custom course colors/names
 - [ ] Post search
 - [ ] Post creation
 - [ ] Post tagging

## Building
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
2. In `Secrets (Sensitive).swift`, add your API key
3. Change the bundle identifier and team in the xcodeproj to your own
