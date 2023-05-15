# GlassRoomAPI

Abtraction APIs for The GlassRoom

Wraps the Google APIs

## APIs:
These are the Google Classroom APIs and if they are implemented/tested

### Must-have:
- courses
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [x] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
  - update
    - [x] Implemented
    - [ ] Tested/used
- courses.allases
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
- courses.announcements
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [x] Tested/used
  - modifyAssignees
    - [x] Implemented
    - [ ] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
- courses.courseWork
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [x] Tested/used
  - modifyAssignees
    - [x] Implemented
    - [ ] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
- courses.courseWorkMaterials
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
- courses.students
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - ist
    - [x] Implemented
    - [ ] Tested/used
- courses.teachers
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
- courses.topics
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
- invitations
  - accept
    - [x] Implemented
    - [ ] Tested/used
  - create
    - [x] Implemented
    - [ ] Tested/used
  - delete
    - [x] Implemented
    - [ ] Tested/used
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
- userProfiles
  - get
    - [x] Implemented
    - [ ] Tested/used

### Could-have:
- courses.courseWork.studentSubmissions
  - get
    - [x] Implemented
    - [ ] Tested/used
  - list
    - [x] Implemented
    - [ ] Tested/used
  - modifyAttachments
    - [x] Implemented
    - [ ] Tested/used
  - patch
    - [x] Implemented
    - [ ] Tested/used
  - reclaim
    - [x] Implemented
    - [ ] Tested/used
  - return
    - [x] Implemented
    - [ ] Tested/used
  - turnIn
    - [x] Implemented
    - [ ] Tested/used
  
### Dont-need-to-have:
- registrations
  - create
    - [ ] Implemented
    - [ ] Tested/used
  - delete
    - [ ] Implemented
    - [ ] Tested/used
- userProfiles.guardianInvitations
  - create
    - [ ] Implemented
    - [ ] Tested/used
  - get
    - [ ] Implemented
    - [ ] Tested/used
  - list
    - [ ] Implemented
    - [ ] Tested/used
  - patch
    - [ ] Implemented
    - [ ] Tested/used
- userProfiles.guardians
  - delete
    - [ ] Implemented
    - [ ] Tested/used
  - get
    - [ ] Implemented
    - [ ] Tested/used
  - list
    - [ ] Implemented
    - [ ] Tested/used

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

- [x] courses.students
  - [x] Student: S

- [x] courses.teachers
  - [x] Teacher: S

- [x] courses.topics
  - [x] Topic: S

- [x] invitations
  - [x] Invitation: S

- [x] userProfiles
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
- [ ] registrations (this seems to be notifications)
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
