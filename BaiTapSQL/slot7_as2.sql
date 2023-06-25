create database slot_7
go
use slot_7
go
create table hang_san_xuat(
	ma_so_hang int primary key,
	ten_hang varchar(20),
	dia_chi varchar(20),
	dien_thoai varchar(10)
);
create table san_pham(
	ma_san_pham int identity primary key,
	ma_so_hang int,
	ten_san_pham nvarchar(100),
	mo_ta_san_pham nvarchar(100),
	don_vi nvarchar(10),
	gia int,
	so_luong int,
	constraint sp_hang foreign key (ma_so_hang) references hang_san_xuat(ma_so_hang)
);
insert into hang_san_xuat values (123, 'Asus', 'USA', '983232'),
								(456, 'MSI', 'China', '123456'),
								(789, 'MBI', 'USA', '121355')
insert into san_pham values (123, 'Máy tính T450', 'Máy nhập cũ', 'Chiếc', 1000, 10),
							(123, 'Điện thoại Nokia5670', 'Điện thoại đang hot', 'Chiếc', 200, 200),
							(123, 'Máy in Samsung 450', 'Máy in đang loại bình', 'Chiếc', 100, 10),
							(456, 'Máy tính MSI', 'Máy tính mới', 'Cái', 2000, 50),
							(456, 'Máy tính bảng abc', 'Máy tính bảng mới', 'Cái', 1500, 100),
							(456, 'Đồng hồ casio', 'Đồng hồ đeo chân', 'Cái', 3000, 20),
							(789, 'Máy tính MBI', 'Máy đời cũ', 'Chiếc', 100, 5),
							(789, 'Điện thoại xyz', 'Điện thoại cũ', 'Chiếc', 1000, 100),
							(789, 'Đồng hồ asf', 'Đồng hồ treo tường', 'Chiếc', 190, 60)

--4a: hien thi hang san xuat
select ten_hang from hang_san_xuat
--4b: hien thi tat ca san pham
select ten_san_pham from san_pham
--5a: liet ke danh sach hang theo thu tu nguoc voi alphabet cua ten
select * from hang_san_xuat order by ten_hang desc
--5b: liet ke danh sach san pham cua cua hang theo thu tu gia giam dan
select * from san_pham order by gia desc;
--5c: hien thi thong tin cua hang Asus
select * from hang_san_xuat where ten_hang like 'Asus';
--5d: Liệt kê danh sách sản phẩm còn ít hơn 11 chiếc trong kho
select * from san_pham where so_luong < 11;
--5e: Liệt kê danh sách sản phẩm của hãng Asus
select ten_san_pham, ten_hang, mo_ta_san_pham from san_pham s join hang_san_xuat h on s.ma_so_hang = h.ma_so_hang where ten_hang like 'Asus';
--6a: Số hãng sản phẩm mà cửa hàng có
select COUNT(*) So_hang_san_xuat from hang_san_xuat;
--6b: Số mặt hàng mà cửa hàng bán
select COUNT(ten_san_pham) So_san_pham from san_pham;
--6c: Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng
SELECT
    COUNT(CASE WHEN s.ma_so_hang = 123 THEN 1 END) AS hang1,
    COUNT(CASE WHEN s.ma_so_hang = 456 THEN 1 END) AS hang2,
    COUNT(CASE WHEN s.ma_so_hang = 789 THEN 1 END) AS hang3
FROM san_pham s
JOIN hang_san_xuat h
ON s.ma_so_hang = h.ma_so_hang;
--6d:
--7a: Thay đổi trường giá tiền của từng mặt hàng là dương
alter table san_pham add constraint gia_duong check (gia>0);
--7b: Thay đổi số điện thoại bắt đầu bằng 0
update hang_san_xuat
set dien_thoai = '0123456789';
alter table hang_san_xuat add constraint so_dien_thoai check (left(dien_thoai,1) = '0');
--7c: Đã xác định khóa chính và khóa ngoại
--8a: Lập index cho tên hàng và mô tả hàng
create index ten_mo_ta on san_pham(ten_san_pham, mo_ta_san_pham);
--8b: Lập View_sanPham và View_SanPham_Hang
create view View_SanPham as
select ma_san_pham, ten_san_pham, gia
from san_pham;
create view View_SanPham_Hang as
select ma_san_pham, ten_san_pham, ten_hang
from san_pham s join hang_san_xuat h on h.ma_so_hang = s.ma_so_hang;
--8c: Store procedure
create procedure SP_SanPham_TenHang @ten_hang varchar(20)
as select ten_san_pham, mo_ta_san_pham, don_vi, gia, h.ten_hang from san_pham s join hang_san_xuat h on s.ma_so_hang = h.ma_so_hang where h.ten_hang = @ten_hang;

create procedure SP_SanPham_Gia @gia int as
select * from san_pham s where s.gia >= @gia;

create procedure SP_SanPham_HetHang as
select * from san_pham s where s.so_luong = 0;
