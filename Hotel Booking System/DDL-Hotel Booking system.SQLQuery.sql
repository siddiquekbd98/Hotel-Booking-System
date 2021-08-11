Create Database HotelBooking
On Primary
(Name = N'HotelBooking_Data_1', Filename = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SADIA\MSSQL\DATA\HotelBooking_Data_1.mdf',
Size = 25MB, Maxsize = 100MB, Filegrowth = 5%)
Log On
(Name = N'HotelBooking_Log_1', Filename = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SADIA\MSSQL\DATA\HotelBooking_Log_1.ldf',
Size = 2MB, Maxsize = 50MB, Filegrowth = 1%)
Go


Use HotelBooking
Go
Create table Room
(
Room_No int Primary key not null,
Room_Type varchar(50),
Rate money
);
Go


Create table Hotel
(
Hotel_ID int Primary key not null,
H_Name varchar(50),
H_Phone numeric,
H_Address varchar(60),
H_City varchar(60),
H_State varchar(60),
H_Zip numeric
);
Go

Create table Guest
(
Guest_ID int Primary key not null,
First_Name varchar(50),
Last_Name varchar(50),
Phone_No numeric,
Address varchar(60),
Email varchar(60)
);
Go


Create table Bookings
(
Booking_No int Primary key not null,
No_of_People int,
Arrive_Date varchar(30),
Depart_Date varchar(30),
payment_method varchar(10),
Amount_total varchar(10)
);
Go
select * from Bookings


Create table Reservation
(

Hotel_ID int references Hotel(Hotel_ID),
Room_No int references Room(Room_No),
Guest_ID int references Guest(Guest_ID),
Booking_No int references Bookings(Booking_No),
primary key (Hotel_ID,Room_No,Guest_ID,Booking_No),
);
Go


------------index------------
create NONCLUSTERED INDEX Reservation on Reservation(Hotel_ID)

         ---------VIEW---------
create view Hotels as select
 Hotel.Hotel_ID,Hotel.H_Name,Room.Room_No,Room.Room_Type,Guest.Guest_ID,Guest.First_Name,
Guest.Phone_No,Bookings.Payment_Method,Bookings.Amount_total,Bookings.Booking_No
from  Reservation
join Hotel on Reservation.Hotel_ID = Hotel.Hotel_ID
join Room on Reservation.Room_No = Room.Room_No
join Guest on Reservation.Guest_ID = Guest.Guest_ID
join Bookings on Reservation.Booking_No = Bookings.Booking_No


------table for merge row----
create table Guest_Merge(
	Guest_ID int , 
 First_Name varchar(10)not null,
 Phone_No varchar(30)not null unique,
 Email varchar(100)not null,
 Address varchar(250)
	)
	GO
--------------sp_insert-------------
create proc sp_insertHotel
@Hotel_ID int,
@H_Name varchar(50),
@H_Phone numeric,
@H_Address varchar(60),
@H_City varchar(60),
@H_State varchar(60),
@H_Zip numeric

as
begin
insert into Hotel(Hotel_ID,H_Name,H_Phone,H_Address,H_City,H_State,H_Zip)
values(@Hotel_ID,@H_Name,@H_Phone,@H_Address,@H_City,@H_State,@H_Zip)
end;
go


--------------sp_Update-------------
create proc sp_updateHotel
@Hotel_ID int,
@H_Name varchar(50),
@H_Phone numeric,
@H_Address varchar(60),
@H_City varchar(60),
@H_State varchar(60),
@H_Zip numeric

as
update Hotel set H_Name=@H_Name
where Hotel_ID=@Hotel_ID

go

----------sp_delete--------------
create proc sp_deletefromHotel
@Hotel_ID int
as
begin
delete from Hotel where Hotel_ID=@Hotel_ID
end;
go

-----------scaler value fn-----------
create function FnGuests
()
returns int
begin
declare @c int;
select @c = count(*)from Guest;
return @c;
end;
GO
select  dbo.FnGuests();
GO


-------------table value fn-------------
create function fn_ListofGuests()
Returns table
Return
(
select Room.Room_Type,rate,Hotel.H_Name,H_Phone,H_City,Guest.First_Name,Last_Name
from reservation join room on room.Room_No = Reservation.Room_No
join Hotel on hotel.Hotel_ID = reservation.Hotel_ID
join Guest on Guest.Guest_ID = Reservation.Guest_ID
)

go


---------------------------- trigger----------------------------------------------
-----CREATE trigger Guest_TABLE-------
CREATE TABLE tr_Guest(
	 Guest_id INT NOT NULL,
	 First_name VARCHAR(50),
	 email VARCHAR(50),
	 Address  VARCHAR(50),
	 Phone_No  VARCHAR(50),
	PRIMARY KEY(Guest_id));
GO
CREATE TABLE tr_Guest_backup(
	 Guest_id INT NOT NULL,
	 First_name VARCHAR(50),
	 email VARCHAR(50),
	 Address  VARCHAR(50),
	 Phone_No  VARCHAR(50),
	 PRIMARY KEY(Guest_id));
GO
-----CREATE trigger Guest_insert-------
CREATE TRIGGER  tr_Guest_insert
On tr_Guest
After Insert, Update
As
Insert Into tr_Guest_backup(Guest_id,First_name,Phone_No,Address,email)
Select i.Guest_id,i.First_name,i.Phone_No,i.Address,i.email From inserted i;
Go
-----INSERT tr_students TABLE -------
insert into tr_Guest values(1,'abu',988,'chuadanga','siddiquekbd98@gmail.com')
insert into tr_Guest values(2,'sheikh',778,'chuadnaga','zim@gmail.com')
insert into tr_Guest values(3,'abu',765,'dhaka','sayem@gmail.com')
insert into tr_Guest values(4,'ahonaf',790,'dhaka','akib@gmail.com')

-----SHOW  tr_Guest TABLE -------
SELECT  * FROM tr_Guest
SELECT  * FROM tr_Guest_backup


-------------------In paramiter and one out parameter--------------

Create Proc spGuest
@Guest_ID int,
@First_name varchar(50),
@Last_name varchar(50),
@phone_No varchar(50),
@email varchar(70),
@address varchar(100)
As
Insert Into Guest(Guest_ID,First_name,Last_name,phone_No,address,email)
Values(@Guest_ID,@First_name,@Last_name,@phone_No,@address,@email);
Go

Exec spGuest 5,'rafsan','farhan',998,'rajsahi','siddiquecbd98@gmail.com';
