create database slot_9
go
use slot_9
go
--Tạo bảng
create table loai_san_pham (
	ma_loai_sp char(4) primary key,
	ten_loai_sp nvarchar(255)
);
create table nguoi_chiu_trach_nhiem (
	ma_nguoi_chiu_trach_nhiem int primary key,
	ten_nguoi_chiu_trach_nhiem nvarchar(255)
);
create table san_pham (
	ma_san_pham char(9) primary key,
	ngay_san_xuat date,
	ma_loai_sp char(4),
	ma_nguoi_chiu_trach_nhiem int,
	foreign key (ma_loai_sp) references loai_san_pham(ma_loai_sp),
	foreign key (ma_nguoi_chiu_trach_nhiem) references nguoi_chiu_trach_nhiem(ma_nguoi_chiu_trach_nhiem)
);
--Chèn dữ liệu vào bảng 
insert into nguoi_chiu_trach_nhiem values (987688, N'Nguyễn Văn An'), (666888, N'Nguyễn Văn Bình'), (345678, N'Đinh Tiến Dũng');
insert into loai_san_pham values ('Z37E', N'Máy tính xách tay Z37'), ('CS20', N'Đồng hồ Casio 20'), ('NO1A', N'Điện thoại cục gạch nokia'),
('SamS', N'Tivi màn hình cong Samsung');
insert into san_pham values ('Z37111111', '12/12/09', 'Z37E', 987688), ('CS2012345', '11/11/01', 'CS20', 987688),
							('Z37111222', '12/12/10', 'Z37E', 987688), ('NO1A12355', '10/10/20', 'NO1A', 987688),
							('CS2013579', '10/10/10', 'CS20', 666888), ('NO1A98765', '09/09/09', 'NO1A', 666888),
							('NO1A23456', '08/08/08', 'NO1A', 345678), ('NO1A01234', '07/07/07', 'NO1A', 345678);
--4a: Danh sách loại sản phẩm của công ty
select * from loai_san_pham;
--4b: Danh sách sản phẩm
select * from san_pham;
--4c: Danh sách người chịu trách nhiệm của công ty
select * from nguoi_chiu_trach_nhiem;
--5a: Danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
select * from loai_san_pham order by ten_loai_sp asc;
--5b: Danh sách người chịu trách nhiệm theo thứ tự tăng dần của tên
select * from nguoi_chiu_trach_nhiem order by ten_nguoi_chiu_trach_nhiem asc;
--5c: Các sản phẩm có loại Z37E
select * from san_pham where ma_loai_sp like 'Z37E';
--5d: Các sản phẩm Nguyễn Văn An Chịu trách nhiệm theo thứ tự giảm dần của mã
select * from san_pham s join nguoi_chiu_trach_nhiem n on s.ma_nguoi_chiu_trach_nhiem = n.ma_nguoi_chiu_trach_nhiem where n.ten_nguoi_chiu_trach_nhiem like N'Nguyễn Văn An' order by ma_san_pham desc;
--6a: Số sản phẩm của từng loại sản phẩm
select ten_loai_sp, COUNT(ma_san_pham) so_luong from loai_san_pham l join san_pham s on s.ma_loai_sp = l.ma_loai_sp group by ten_loai_sp;
--6b: Số loại sản phẩm trung bình theo loại sản phầm
SELECT AVG(count) as avg_count
FROM (
    SELECT ma_loai_sp, COUNT(ma_san_pham) as count
    FROM san_pham
    GROUP BY ma_loai_sp
) subquery;
--6c: Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm
select * from san_pham as s join loai_san_pham as l on l.ma_loai_sp = s.ma_loai_sp;
--6d: Hiển thị toàn bộ thông tin về người chịu trách nhiệm, sản phẩm và loại sản phẩm
select * from san_pham as s 
join loai_san_pham as l on l.ma_loai_sp = s.ma_loai_sp 
join nguoi_chiu_trach_nhiem n on n.ma_nguoi_chiu_trach_nhiem = s.ma_nguoi_chiu_trach_nhiem;
--7a: Thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại
update san_pham 
set ngay_san_xuat = GETDATE()
where ngay_san_xuat > GETDATE();
alter table san_pham add constraint ngay check (ngay_san_xuat <= getdate());
--7b: Đã xác định trường khóa chính và khóa ngoại
--7c: Thêm trường phiên bản của sản phẩm
alter table san_pham add phien_ban nvarchar(30); 
--8a: Đặt index cho cột tên người chịu trách nhiệm
create index in_nguoi_chiu_trach_nhiem on nguoi_chiu_trach_nhiem(ten_nguoi_chiu_trach_nhiem);
--8b: Tạo các view
--View_SanPham
create view View_SanPham as
select ma_san_pham, ngay_san_xuat, ten_loai_sp
from san_pham s join loai_san_pham l on s.ma_loai_sp = l.ma_loai_sp;
--View_SanPham_NCTN 
create view View_SanPham_NCTN as 
select ma_san_pham, ngay_san_xuat, ten_nguoi_chiu_trach_nhiem
from san_pham s join nguoi_chiu_trach_nhiem n on s.ma_nguoi_chiu_trach_nhiem = n.ma_nguoi_chiu_trach_nhiem;
--View_Top_SanPham
create view View_Top_SanPham as
select top 5 ma_san_pham,ten_loai_sp,ngay_san_xuat 
from san_pham s join loai_san_pham l on s.ma_loai_sp = l.ma_loai_sp order by ngay_san_xuat desc; 
--8c: Store Procedure
--SP_Them_Loai_SP
create proc SP_Them_Loai_SP @ma char(4), @ten nvarchar (255)
as
begin
	insert into loai_san_pham values (@ma, @ten)
end
--SP_Them_NCTN
create proc SP_Them_NCTN @maNCTN int, @tenNCTN nvarchar(255)
as
begin
	insert into nguoi_chiu_trach_nhiem values (@maNCTN, @tenNCTN)
end
--SP_Them_SanPham
CREATE PROCEDURE SP_Them_SanPham @ma_san_pham char(9), @ngay_san_xuat date, @ma_loai_sp char(4), @ma_nguoi_chiu_trach_nhiem int
AS
BEGIN
    INSERT INTO san_pham (ma_san_pham, ngay_san_xuat, ma_loai_sp, ma_nguoi_chiu_trach_nhiem)
    VALUES (@ma_san_pham, @ngay_san_xuat, @ma_loai_sp, @ma_nguoi_chiu_trach_nhiem);
END;
--SP_Xoa_SanPham
create procedure SP_Xoa_SanPham @ma_SP char(9)
as
begin
	delete from san_pham where ma_san_pham = @ma_SP;
end;
--SP_Xoa_SanPham_TheoLoai
create proc SP_Xoa_SanPham_TheoLoai @ma_loai char(4)
as
begin
	delete from san_pham where ma_loai_sp = @ma_loai;
end;

