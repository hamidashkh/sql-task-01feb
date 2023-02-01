Create database LibraryDB

use LibraryDB

Create table Books
(
	Id int identity Primary Key,
	Name nvarchar(100) Check(Len(Name)>=2 AND Len(Name)<=100),
	PageCount int Check(PageCount>=10)
)

Create table Authors
(
	Id int identity Primary Key,
	Name nvarchar(10),
	Surname nvarchar(100)
)

Alter table Books
add AuthorId int Foreign Key References Authors(Id)

Insert Into Authors
Values
('Leo','Tolstoy'),
('William','Shakespeare'),
('James','Joyce')

Insert Into Books
Values
('Anna Karenina',864,1),
('Romeo and Juliet',156,2),
('Dubliners',152,3)

Create View usv_GetBookInfo
as
Select b.Name as BookName,
b.PageCount,
a.Name+' '+a.Surname as FullName
From Books b
Join Authors a
On b.AuthorId=a.Id


Create Procedure  usp_GetSearchByName
@name nvarchar(100)
As
Begin
	Select * From usv_GetBookInfo
	Where BookName Like'%@name%' OR FullName Like'%@name%'
End

Create Table ArchiveAuthors
(
	Id int,
	Name nvarchar(10),
	Surname nvarchar(100),
	Date DateTime2,
	StatementType nvarchar(100)
)

Create Trigger AuthorChanges
on Authors
after insert
as
Begin
	declare @id int
	declare @name nvarchar(10)
	declare @surname nvarchar(100)
	declare @date DateTime2
	declare @statementType nvarchar(100)

	Select @id = a.Id From inserted a
	Select @name = a.Name From inserted a
	Select @surname=a.Surname From inserted a
	Select @date = GETUTCDATE() From inserted a
	Select @statementType = 'Inserted' From inserted a

	Insert Into ArchiveAuthors(Id, Name,Surname, Date, StatementType)
	Values
	(@id,@name,@surname,@date,@statementType)
End