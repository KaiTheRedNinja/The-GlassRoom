# GlassRoomAPI

Abtraction APIs for The GlassRoom

Wraps the Google APIs

## Types needed:
These are the types needed for each of the APIs. An S indicates a struct, an E indicates an enum.

### Must-have:
- [x] courses
  - [x] Course: S
  - [x] CourseState: E
  - [x] CourseMaterialSet: S
  - [x] CourseMaterial: E (NOTE: arrives as json, but can be represented as an enum)
  - [x] GradebookSettings: S
  - [x] CalculationType: E
  - [x] DisplaySetting: E

- [x] courses.aliases
  - [x] CourseAlias: S

- [x] courses.announcements
  - [x] Announcement: S
  - [x] AnnouncementState: E

- [x] courses.courseWork
  - [x] CourseWork: S
  - [x] CourseWorkState: E
  - [x] Date: S
  - [x] TimeOfDay: S
  - [x] SubmissionModificationMode: S
  - [x] Assignment: S
  - [x] MultipleChoiceQuestion: S

- [x] courses.courseWorkMaterials
  - [x] CourseWorkMaterial: S
  - [x] CourseWorkMaterialState: E

- [ ] courses.students
  - [x] Student: S

- [ ] courses.teachers
  - [x] Teacher: S

- [ ] courses.topics
  - [x] Topic: S

- [ ] courses.invitations
  - [x] Invitation: S

- [ ] courses.userProfiles
  - [x] UserProfile: S
  - [x] Name: S
  - [x] GlobalPermission: S
  - [x] Permission: E

### Could-have:
- [ ] courses.courseWork.studentSubmissions
  - [x] StudentSubmission: S
  - [x] SubmissionState: E
  - [x] AssignmentSubmission: S
  - [x] Attachment: S
  - [x] ShortAnswerSubmission: S
  - [x] MultipleChoiceSubmission: S
  - [x] SubmissionHistory: S
  - [x] StateHistory: S
  - [x] State: E
  - [x] GradeHistory: S
  - [x] GradeChangeType: S

### Dont-need-to-have:
- [ ] courses.registrations (this seems to be notifications)
  - [x] Registration: S
  - [x] Feed: S
  - [x] FeedType: E
  - [x] CourseRosterChangesInfo: S
  - [x] CourseWorkChangesInfo: S
  - [x] CloudPubsubTopic: S

- [ ] courses.guardianInvitations (We dont need guardians)
  - [x] GuardianInvitation: S
  - [x] GuardianInvitationState: S

- [ ] courses.guardians
  - [x] Guardian: S
