insert into Room values(1,'vip','5000')

insert into Hotel values (1,'kfc','345','mirpur','bangladesh','dhaka','89'),
(2,'gfc','346','demra','bangladesh','dhaka','90'),
(3,'moubon','567','kushtia sadar','bangladesh','kushtia','44'),
(4,'vogon bilash','765','chuadanga sadar','bangladesh','chuadanga','23');

insert into guest values(1,'abu','bakor',988,'chuadanga','siddiquekbd98@gmail.com')
insert into guest values(2,'sheikh','zim',778,'chuadnaga','zim@gmail.com')
insert into guest values(3,'abu','sayem',765,'dhaka','sayem@gmail.com')
insert into guest values(4,'ahonaf','akib',790,'dhaka','akib@gmail.com')


insert into Bookings(Booking_No,No_of_People,Arrive_Date,Depart_Date,payment_method,Amount_total)
values(1,2,'12-12-2012 8:19:00','15-12-2012 8:29:00','card','4888'),
(2,3,'12-12-2012 8:30:00','15-12-2012 8:45:00','internet','5888'),
(3,8,'14-12-2012 8:35:00','16-12-2012 8:49:00','card','522222')

insert into Reservation values(1,1,1,1),
(2,1,2,2),
(3,1,3,3),
(4,1,4,1)

select * from Room;
select * from Bookings;
select * from Hotel;
select * from Guest;
select * from Reservation


                           -----------JOIN----------------

select Hotel.Hotel_ID,Hotel.H_Name,Room.Room_No,Room.Room_Type,Guest.Guest_ID,Guest.First_Name,
Guest.Phone_No,Bookings.Payment_Method,Bookings.Amount_total,Bookings.Booking_No
from  Reservation
join Hotel on Reservation.Hotel_ID = Hotel.Hotel_ID
join Room on Reservation.Room_No = Room.Room_No
join Guest on Reservation.Guest_ID = Guest.Guest_ID
join Bookings on Reservation.Booking_No = Bookings.Booking_No


    ------Sub query-------

SELECT * 
   FROM Hotel
   WHERE Hotel_ID IN (SELECT Hotel_ID
         FROM Hotel 
         WHERE H_Zip >45 );
select * from Hotel

            -------Group by-------

select COUNT (Hotel_ID),
H_Name from Hotel
group by H_Name

             -------------Having--------

select count (Hotel_ID),H_Phone from Hotel
group by H_Phone
Having Count (Hotel_ID)<2


                  --------------CASE------------

select Guest.First_Name,Guest.Last_Name,
case
when First_name='sheikh' then 'VIP CUSTOMER'
when First_name='ahonaf' then 'Senior customer'
else 'Regular Customer'
end as comments
from Reservation
join Guest on Reservation.Guest_ID = Guest.Guest_ID
GO


              -----------CTE------------
WITH Guest_CTE (First_name,Phone_no)
AS
(SELECT
        First_name,
		Phone_no
 FROM   Guest)
SELECT First_name,
		Phone_no
FROM   Guest_CTE

         ----------------MERGE-----------------
	merge into dbo.Guest_Merge as GM
	using dbo.Guest as GI
	on GM.Guest_ID = GI.Guest_ID
	when matched then 
	update set GM.First_Name = GI.First_Name
	when NOT matched then
	insert (Guest_ID,First_Name,Phone_No,Email,Address)
	values(GI.Guest_ID,GI.First_Name,GI.Phone_No,GI.Email,GI.Address);
	GO

 -------------Rollup-------------

SELECT
Guest_id  FROM Guest
GROUP BY rollup (Guest_id);