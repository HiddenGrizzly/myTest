create database slot_8
GO
use slot_8
GO
--2: Tạo bảng
create table khach_hang (
	ma_khach_hang int identity primary key,
	ten_khach_hang nvarchar(50),
	so_CMND varchar(15),
	dia_chi nvarchar(100)
);
create table so_thue_bao (
	so_thue_bao varchar(15) primary key,
	loai_thue_bao nvarchar(20),
	ngay_dang_ky date,
	ma_khach_hang int foreign key references khach_hang(ma_khach_hang)
);
--3: Chèn dữ liệu
insert into khach_hang values (N'Nguyễn Nguyệt Nga', '123456789', N'Hà Nội'),
							  (N'Nguyễn Nga Nguyệt', '987654321', N'Quảng Ninh'),
							  (N'Nguyễn Văn An', '125125616', N'Thái Bình'),
							  (N'Đào Thị H', '1251515151', N'Tây Ninh');
insert into so_thue_bao values ('123456789', N'Trả trước', '12/12/02', 1),
							   ('124151515', N'Trả sau', '12/10/03', 1),
							   ('153135236', N'Trả trước', '10/10/04', 2),
							   ('151616677', N'Trả trước', '11/11/11',2),
							   ('161727278', N'Trả trước', '1/1/1', 3),
							   ('125151616', N'Trả sau', '02/02/02', 4),
							   ('0123456789', N'Trả sau', '10/10/10', 4)
--4a: Hiển thị thông tin khách hàng
select * from khach_hang;
--4b: Hiển thị thông tin các số thuê bao
select * from so_thue_bao;
--5a: Hiển thị thông tin thuê bao số 0123456789
select ten_khach_hang, dia_chi, so_CMND, so_thue_bao,loai_thue_bao, ngay_dang_ky from so_thue_bao t join khach_hang k on t.ma_khach_hang = k.ma_khach_hang where t.so_thue_bao = '0123456789';
--5b: Hiển thị thông tin khách hàng có số cmnd 123456789
select * from khach_hang where so_CMND = '123456789';
--5c: Hiển thị các số thuê bao của khách hàng có số CMND 123456789
select * from so_thue_bao s join khach_hang k on s.ma_khach_hang = k.ma_khach_hang where k.so_CMND = '123456789';
--5d: Hiển thị các thuê bao đăng ký vào ngày 12/12/09
select * from so_thue_bao where ngay_dang_ky = '12/12/09';
--5e: Liệt kê các thuê bao có địa chỉ Hà Nội
select * from so_thue_bao s join khach_hang k on k.ma_khach_hang = s.ma_khach_hang where dia_chi like N'Hà Nội';
--6a: Tổng số khách hàng của công ty
select COUNT(ma_khach_hang) So_khach_hang from khach_hang;
--6b: Tổng số thuê bao của công ty
select COUNT(*) Luong_thue_bao from so_thue_bao;
--6c: Tổng số thuê bao đăng ký ngày 12/12/09
select COUNT(*) Luong_thue_bao from so_thue_bao where ngay_dang_ky = '12/12/09';
--6d: Hiển thị thông tin toàn bộ khách hàng và số thuê bao
select ten_khach_hang, dia_chi, so_CMND, so_thue_bao,loai_thue_bao, ngay_dang_ky from so_thue_bao t join khach_hang k on t.ma_khach_hang = k.ma_khach_hang;
--7a: Thay đổi trường ngày đăng ký not null
alter table so_thue_bao alter column ngay_dang_ky date not null;
--7b: Thay đổi trường ngày đăng ký là trước hoặc bằng ngày hiện tại
update so_thue_bao
set ngay_dang_ky = GETDATE()
where ngay_dang_ky > GETDATE();
alter table so_thue_bao add constraint ngay_hien_tai check (ngay_dang_ky <= getdate());
--7c: Thay đổi số điện thoại bắt đầu bằng 09
update so_thue_bao 
set so_thue_bao = '09' + SUBSTRING(so_thue_bao, 1, LEN(so_thue_bao))
where so_thue_bao not like '09%';
alter table so_thue_bao add constraint dien_thoai check (so_thue_bao like '09%');
--7d: Thêm trường số điểm thưởng cho mỗi số thuê bao
alter table so_thue_bao add diem_thuong int;
--8a: Đặt chỉ mục cho cột tên khách hàng
create index tim_theo_ten on khach_hang(ten_khach_hang);
--8b: Viết các view
--View_KhachHang
create view View_KhachHang as 
select ma_khach_hang, ten_khach_hang, dia_chi from khach_hang;
--View_KhachHang_ThueBao
create view View_KhachHang_ThueBao as
select k.ma_khach_hang, ten_khach_hang, so_thue_bao from khach_hang k join so_thue_bao s on s.ma_khach_hang = k.ma_khach_hang;
--8c: Viết các store procedure
--SP_TimKH_ThueBao
create proc SP_TimKH_ThueBao @thue_bao varchar(15)
as
begin
	select * from khach_hang k join so_thue_bao s on s.ma_khach_hang = k.ma_khach_hang where s.so_thue_bao = @thue_bao
end;
exec SP_TimKH_ThueBao '09123456789';