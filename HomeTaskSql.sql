CREATE DATABASE BlogDB
USE BlogDB


CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL UNIQUE)


INSERT INTO Categories (Name)
VALUES ('Category 1'),
       ('Category 2'),
       ('Category 3'),
       ('Category 4'),
       ('Category 5');
       


CREATE TABLE Tags(
[Id] INT  PRIMARY KEY IDENTITY,
Name NVARCHAR(60) NOT NULL UNIQUE
)


INSERT INTO Tags (Name)
VALUES ('Tag 1'),
       ('Tag 2'),
       ('Tag 3'),
       ('Tag 4'),
       ('Tag 5');

CREATE TABLE Users(
[Id] INT  PRIMARY KEY IDENTITY,
[UserName] NVARCHAR(60) NOT NULL UNIQUE,
[FullName] NVARCHAR(60) NOT NULL,
[Age] INT CHECK (Age >= 0 AND Age <= 150))



INSERT INTO Users (UserName, FullName, Age)
VALUES ('user1', 'fullname1', 25),
       ('user2', 'fullname2', 37),
       ('user3', 'fullname3', 26),
       ('user4', 'fullname4', 25),
       ('user5', 'fullname5', 32);
       



Create TABLE Blogs(
Id INT  PRIMARY KEY IDENTITY,
[Title] NVARCHAR(50) NOT NULL,
Description NVARCHAR(50) NOT NULL,
isDeleted BIT DEFAULT 0,
UsersId INT FOREIGN KEY REFERENCES Users(Id),
CategoriesId INT FOREIGN KEY REFERENCES Categories(Id))


INSERT INTO Blogs (Title, Description, UsersId, CategoriesId)
VALUES ('Title 1', 'Description 1', 1, 1),
       ('Title 2', 'Description 2', 2, 2),
       ('Title 3', 'Description 3', 3, 1),
       ('Title 4', 'Description 4', 4, 2),
       ('Title 5', 'Description 5', 5, 3);

CREATE TABLE Comments(
Id INT  PRIMARY KEY IDENTITY,
[Content] NVARCHAR(250) NOT NULL,
UsersId INT FOREIGN KEY REFERENCES Users(Id),
BlogsId INT FOREIGN KEY REFERENCES Blogs(Id))

INSERT INTO Comments ( Content , UsersId, BlogsId)
VALUES ('Content 1', 4, 1),
       ('Content 2', 2, 2),
       ('Content 3', 3, 1),
       ('Content 4', 4, 2),
       ('Content 5', 5, 3);


CREATE TABLE Blogs_Tags(
BlogsId INT FOREIGN KEY REFERENCES Blogs(Id),
TagsId INT FOREIGN KEY REFERENCES Tags(Id),
PRIMARY KEY(BlogsId,TagsId))

INSERT INTO Blogs_Tags (BlogsId,TagsId)
VALUES (4, 1),
       (2, 2),
       (3, 1),
       (4, 2),
       (5, 3);


CREATE VIEW VW_BlogsByData
AS
SELECT B.Title AS 'BlogsTitle' , U.UserName, U.FullName 
FROM Blogs B
JOIN Users U
ON U.Id=B.UsersId

SELECT*FROM VW_BlogsByData



CREATE VIEW VW_BlogsandCategory
AS
SELECT B.Title AS 'BlogsTitle', C.Name FROM Blogs B
JOIN Categories C
ON C.Id=B.CategoriesId

SELECT*FROM vw_BlogsandCategory


CREATE PROCEDURE SP_GetComments @UsersId INT
AS
SELECT C.Id, C.Content FROM Comments C
JOIN Users U
ON U.Id=C.UsersId
WHERE U.Id=@UsersId

EXEC SP_GetComments 3

CREATE PROCEDURE SP_GetBlogs @UsersId INT
AS
SELECT B.Id, B.Title, B.Description FROM Blogs B
JOIN Users U
ON U.Id=B.UsersId
WHERE U.Id=@UsersId

EXEC SP_GetBlogs 1


CREATE FUNCTION UFN_GetBlogsCount(@categoriesId INT)
RETURNS INT

BEGIN
DECLARE @Count INT
SELECT @Count=COUNT(@categoriesId) FROM Blogs
WHERE CategoriesId=@categoriesId
RETURN @Count
END

SELECT dbo.UFN_GetBlogsCount(2) AS 'BlogsCount'

CREATE FUNCTION UFN_GetBlogsTable(@userId INT)
RETURNS TABLE 

RETURN
SELECT B.Id, B.Title, B.Description  FROM Blogs B
WHERE B.UsersId=@userId

SELECT*FROM dbo.UFN_GetBlogsTable(4) 

Create TRIGGER TRGR_IsDeleteBlogs
ON Blogs
Instead OF DELETE
AS
BEGIN
   Update Blogs
   Set IsDeleted=1
   from deleted
   Where Blogs.Id=deleted.Id
   
END


Delete Blogs 
Where Blogs.Id=3

Select*from Blogs