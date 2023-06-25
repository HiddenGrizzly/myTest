create database slot10_as5
use slot10_as5
--2: Viết các câu lệnh để tạo bảng
create table DanhBa (
	ma_nguoi int primary key,
	ho_va_ten nvarchar(255),
	dia_chi nvarchar(255),
	ngay_sinh date
);
create table DienThoai (
	ma_nguoi int,
	so_dien_thoai varchar(20),
	foreign key (ma_nguoi) references DanhBa(ma_nguoi)
);
--3: Thêm dữ liệu vào bảng
insert into DanhBa (ma_nguoi, ho_va_ten, dia_chi, ngay_sinh) values (1, N'Nguyễn Văn An', N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '11/18/87'),
																	(2, N'Nguyễn Văn Tùng', N'Xóm 2, Đông La, Hoài Đức, Hà Nội', '09/29/95'),
																	(3, N'Đinh Tiến Dũng', N'Đâu đó trên trái đất', '02/03/80');
insert into DienThoai (ma_nguoi, so_dien_thoai) values (1, '987654321'),
													   (1, '09873452'),
													   (1, '09832323'),
													   (1, '09434343'),
													   (2, '0379113133'),
													   (3, '0124151513'),
													   (3, '0365131616'),
													   (3, '0125346215');
--4a: Liệt kê những người có trong danh bạ
select ho_va_ten, dia_chi, ngay_sinh from DanhBa;
--4b: Danh sách số điện thoại có trong danh bạ
select ho_va_ten ,so_dien_thoai from DienThoai dt join DanhBa db on dt.ma_nguoi = db.ma_nguoi;
--5a: Liệt kê danh sách người trong danh bạ theo thứ tự alphabet
select ho_va_ten, dia_chi, ngay_sinh from DanhBa order by ho_va_ten asc;
--5b: Liệt kê số điện thoại của người có tên Nguyễn Văn An
select ho_va_ten, so_dien_thoai from DienThoai dt join DanhBa db on dt.ma_nguoi = db.ma_nguoi where ho_va_ten like N'Nguyễn Văn An';
--5c: Liệt kê những người có ngày sinh là 12/12/09
select * from DanhBa where ngay_sinh = '12/12/09';
--6a: Tìm số lượng số điện thoại của mỗi người trong danh bạ
select ho_va_ten, count(so_dien_thoai) as so_luong from DanhBa db join DienThoai dt on dt.ma_nguoi = db.ma_nguoi group by ho_va_ten;
--6b: Tìm tổng số người trong danh bạ sinh vào tháng 12
select COUNT(ma_nguoi) sinh_thang_12 from DanhBa where MONTH(ngay_sinh) = 12;
--6c: Hiển thị thông tin về người của từng số điện thoại
select * from DienThoai dt join DanhBa db on dt.ma_nguoi = db.ma_nguoi;
--6d: Hiển thị toàn bộ thông tin về người có số điện thoại 123456789
select * from DienThoai dt join DanhBa db on dt.ma_nguoi = db.ma_nguoi where so_dien_thoai = '123456789';
--7a: Thay đổi trường ngày sinh là trước ngày hiện tại
update DanhBa 
set ngay_sinh = getdate() 
where ngay_sinh > getdate();
alter table DanhBa add constraint ngay_sinh_hien_tai check (ngay_sinh < getdate());
--7c:Thêm trường ngày bắt đầu liên lạc
alter table DienThoai add ngay_lien_lac date;
--8a: Thực hiện các chỉ mục
create index IX_HoTen on DanhBa(ho_va_ten);
create index IX_SoDienThoai on DienThoai(so_dien_thoai);
--8b: Viết các view
--View_SoDienThoai
create view View_SoDienThoai as select ho_va_ten, so_dien_thoai from DanhBa db join DienThoai dt on db.ma_nguoi = dt.ma_nguoi;
--View_SinhNhat
create view View_SinhNhat as
select ho_va_ten,ngay_sinh, so_dien_thoai 
from DanhBa db join DienThoai dt on db.ma_nguoi = dt.ma_nguoi 
where MONTH(ngay_sinh) = MONTH(GETDATE());
--8c: Viết các stored procedure
--SP_Them_DanhBa
create proc SP_Them_DanhBa @ma int, @ho_ten nvarchar(255), @dia_chi nvarchar(255), @ngay_sinh date
as
begin
	insert into DanhBa (ma_nguoi, ho_va_ten, dia_chi, ngay_sinh) values (@ma, @ho_ten, @dia_chi, @ngay_sinh);
end;
--SP_Tim_DanhBa
create proc SP_Tim_DanhBa @ho_ten nvarchar(255)
as
begin
	select ho_va_ten, dia_chi, ngay_sinh, so_dien_thoai from DanhBa db join DienThoai dt on db.ma_nguoi = dt.ma_nguoi 
	where ho_va_ten like @ho_ten;
end;
