# GlassRoomAPI

Abtraction APIs for The GlassRoom

Wraps the Google APIs

## Types needed:
These are the types needed for each of the APIs. An S indicates a struct, an E indicates an enum.

### Must-have:
- [ ] courses
  - [ ] Course: S
  - [ ] CourseState: E
  - [ ] CourseMaterialSet: S
  - [ ] CourseMaterial: E (NOTE: arrives as json, but can be represented as an enum)
  - [ ] GradebookSettings: S
  - [ ] CalculationType: E
  - [ ] DisplaySetting: E

- [ ] courses.aliases
  - [ ] CourseAlias: S

- [ ] courses.announcements
  - [ ] Announcement: S
  - [ ] AnnouncementState: E

- [ ] courses.courseWork
  - [ ] CourseWork: S
  - [ ] CourseWorkState: E
  - [ ] Date: S
  - [ ] TimeOfDay: S
  - [ ] SubmissionModificationMode: S
  - [ ] Assignment: S
  - [ ] MultipleChoiceQuestion: S

- [ ] courses.courseWorkMaterials
  - [ ] CourseWorkMaterial: S
  - [ ] CourseWorkMaterialState: E

- [ ] courses.students
  - [ ] Student: S

- [ ] courses.teachers
  - [ ] Teacher: S

- [ ] courses.topics
  - [ ] Topic: S

- [ ] courses.invitations
  - [ ] Invitation: S

- [ ] courses.userProfiles
  - [ ] UserProfile: S
  - [ ] Name: S
  - [ ] GlobalPermission: S
  - [ ] Permission: E

### Could-have:
- [ ] courses.courseWork.studentSubmissions
  - [ ] StudentSubmission: S
  - [ ] SubmissionState: E
  - [ ] AssignmentSubmission: S
  - [ ] Attachment: S
  - [ ] ShortAnswerSubmission: S
  - [ ] MultipleChoiceSubmission: S
  - [ ] SubmissionHistory: S
  - [ ] StateHistory: S
  - [ ] State: E
  - [ ] GradeHistory: S
  - [ ] GradeChangeType: S

### Dont-need-to-have:
- [ ] courses.registrations (this seems to be notifications)
  - [ ] Registration: S
  - [ ] Feed: S
  - [ ] FeedType: E
  - [ ] CourseRosterChangesInfo: S
  - [ ] CourseWorkChangesInfo: S
  - [ ] CloudPubsubTopic: S

- [ ] courses.guardianInvitations (We dont need guardians)
  - [ ] GuardianInvitation: S
  - [ ] GuardianInvitationState: S

- [ ] courses.guardians
  - [ ] Guardian: S
