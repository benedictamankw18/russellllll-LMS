use LMS_DB2;

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL
);

CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    TeacherId INT NOT NULL,
    EnrollmentCode NVARCHAR(20) NOT NULL,
    FOREIGN KEY (TeacherId) REFERENCES Users(UserId)
);

CREATE TABLE Enrollment (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    StudentId INT NOT NULL,
    EnrolledOn DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    FOREIGN KEY (StudentId) REFERENCES Users(UserId)
);

CREATE TABLE Resources (
    ResourceId INT IDENTITY(1,1) PRIMARY KEY,
    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(255) NOT NULL,
    CourseId INT NOT NULL,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Assignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    DueDate DATETIME NOT NULL,
    CourseId INT NOT NULL,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);


CREATE TABLE Quizzes (
    QuizId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    CourseId INT NOT NULL,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Questions (
    QuestionId INT IDENTITY(1,1) PRIMARY KEY,
    QuizId INT NOT NULL,
    Text NVARCHAR(500) NOT NULL,
    OptionA NVARCHAR(200),
    OptionB NVARCHAR(200),
    OptionC NVARCHAR(200),
    OptionD NVARCHAR(200),
    CorrectOption NVARCHAR(1) NOT NULL,
    FOREIGN KEY (QuizId) REFERENCES Quizzes(QuizId)
);

CREATE TABLE Reports (
    ReportId INT IDENTITY(1,1) PRIMARY KEY,
    Type NVARCHAR(50),
    UserId INT,
    CourseId INT,
    Data NVARCHAR(MAX),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

