# GLassroom
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
|---------------------------|:--------------------:|:----------------------:|:----------------------:|
| Launching website/app     |         4.68s        |           N/A          |          0.99s         |
| Loading courses           |         3.50s        |          0.00s         |          1.48s         |
| Loading posts             |         2.80s        |          0.14s         |          1.18s         |
| Loading post's submission |         0.90s        |          0.13s         |          0.31s         |

## Images

Announcements and posts

<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/389e9b26-59bb-4498-89d8-b9454c8bf6f7">
<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/475d411b-9073-4d95-bb9a-06eea3654539">

Aggregate view

<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/93ff9d7d-2588-49df-a5b3-43d2cd2486a9">

Search

<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/ea38c545-1384-45c8-96ac-5f2f397cb064">
<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/bbbf1bfd-7706-48b9-8d40-82eec9c37a66">

![](https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/c9a1c8a7-7fa6-4b8a-8025-19b60f6e20df.gif)

Settings and Customisation

<img width="792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/1447e1c5-00cc-438e-a7d7-917309d2f3d2">
<img width="792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/402f5819-2bd4-40a3-9144-1dc957c9b1ed">

Fancy UI option

<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/0f946152-27ca-4e7a-a446-267a6d7738b5">

Accessibility - Bionic reading

<img width="1792" alt="image" src="https://github.com/KaiTheRedNinja/The-GlassRoom/assets/93832702/f7e6f272-6c7b-4d57-ab04-919e3e620397">


## Building
#### NOTE: This MAY be outdated

Prerequisite: You have a google developer project with an API key capable of utilising Google Classroom and Drive APIs
1. Add your own `The-GlassRoom-Info.plist` file at the top level of the repo, in this format:
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
