CREATE DATABASE BookStore
ON PRIMARY
    (NAME = bookstore,
    FILENAME = 'bookstore_data.mdf',
    SIZE = 4MB,
    MAXSIZE = 4GB),
FILEGROUP bookstore2
    (NAME = bookstore2,
    FILENAME = 'bookstore_data2.ndf',
    SIZE = 2MB,
    MAXSIZE = 2GB)
LOG ON
    (NAME = bookstore_log,
    FILENAME = 'bookstore_log.ldf',
    SIZE = 2MB,
    MAXSIZE = 1GB);
USE BookStore;
CREATE TABLE Publishers (
    MaNhaXuatBan INT PRIMARY KEY,
    TenNhaXuatBan NVARCHAR(255),
    DiaChiNhaXuatBan NVARCHAR(255)
);

CREATE TABLE BookTypes (
    MaLoaiSach INT PRIMARY KEY,
    TenLoaiSach NVARCHAR(255)
);

CREATE TABLE Books (
    MaSach NVARCHAR(255) PRIMARY KEY,
    TenSach NVARCHAR(255),
    TacGia NVARCHAR(255),
    NoiDungTomTat NVARCHAR(MAX),
    NamXuatBan INT,
    LanXuatBan INT,
    GiaBan INT,
    SoLuong INT,
    MaNhaXuatBan INT FOREIGN KEY REFERENCES Publishers(MaNhaXuatBan),
    MaLoaiSach INT FOREIGN KEY REFERENCES BookTypes(MaLoaiSach)
);
--2: Chèn dữ liệu
INSERT INTO Publishers (MaNhaXuatBan, TenNhaXuatBan, DiaChiNhaXuatBan)
VALUES (1, N'Tri Thức', N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội'), (2, N'Kim Đồng', N'248 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội'), (3, N'Giáo Dục', N'81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội');

INSERT INTO BookTypes (MaLoaiSach, TenLoaiSach)
VALUES (1, N'Khoa học xã hội'), (2, N'Toán học'), (3, N'Tin học');

INSERT INTO Books (MaSach, TenSach, TacGia, NoiDungTomTat, NamXuatBan, LanXuatBan, GiaBan, SoLuong, MaNhaXuatBan, MaLoaiSach)
VALUES (N'B001', N'Trí tuệ Do Thái', N'Eran Katz', N'Bạn có muốn biết: Người Do Thái sáng tạo ra cái gì và nguồn gốc trí tuệ của họ xuất phát từ đâu không? Cuốn sách này sẽ dần hé lộ những bí ẩn về sự thông thái của người Do Thái, của một dân tộc thông tuệ với những phương pháp và kỹ thuật phát triển tầng lớp trí thức đã được giữ kín hàng nghìn năm như một bí ẩn mật mang tính văn hóa.', 2010, 1, 79000, 100, 1, 1),
	   (N'B002', N'Toán cao cấp', N'Nguyễn Văn A', N'Cuốn sách giới thiệu các khái niệm và phương pháp giải quyết bài toán trong toán cao cấp.', 2015, 1, 120000, 50, 2, 2),
       (N'B003', N'Lập trình C++', N'Trần Văn B', N'Cuốn sách hướng dẫn lập trình C++ từ cơ bản đến nâng cao.', 2018, 1, 150000, 75, 3, 3);
--3: Liệt kê cuốn sách có năm xuất bản từ 2008 đến nay
SELECT TenSach, NamXuatBan FROM Books WHERE NamXuatBan >= 2008;
--4: Liệt kê 10 cuốn sách có giá bán cao nhất
SELECT TOP 10 * FROM Books ORDER BY GiaBan DESC;
--5: Tìm những cuốn sách tiêu đề có từ tin học
SELECT * FROM Books WHERE TenSach LIKE N'%tin học%';
--6: Liệt kê các cuốn sách có tiêu đề bắt đầu bằng T theo thứ tự giá giảm dần
SELECT * FROM Books WHERE TenSach LIKE N'T%' ORDER BY GiaBan DESC;
--7: Liệt kê các cuốn sách của nhà xuất bản Tri thức
SELECT * FROM Books B JOIN Publishers P ON B.MaNhaXuatBan = P.MaNhaXuatBan WHERE TenNhaXuatBan = N'Tri thức';
--8: Lấy thông tin chi tiết về nhà xuất bản cuốn sách 'Trí tuệ do thái'
SELECT TenNhaXuatBan, DiaChiNhaXuatBan FROM Publishers P JOIN Books B ON B.MaNhaXuatBan = P.MaNhaXuatBan WHERE TenSach = N'Trí tuệ Do Thái';
--9: Hiển thị thông tin về cuốn sách
SELECT MaSach, TenSach, NamXuatBan, TenNhaXuatBan, TenLoaiSach FROM Books B
JOIN Publishers P ON B.MaNhaXuatBan = P.MaNhaXuatBan
JOIN BookTypes T ON T.MaLoaiSach = B.MaLoaiSach;
--10: Tìm cuốn sách có giá bán đắt nhất
SELECT TOP 1 * FROM Books ORDER BY GiaBan DESC;
--11: Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP 1 * FROM Books ORDER BY SoLuong DESC;
--12: Tìm các cuốn sách của tác giả 'Eran Katz'
SELECT * FROM Books WHERE TacGia = N'Eran Katz';
--13: Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước
UPDATE Books 
SET GiaBan = GiaBan * 0.9
WHERE NamXuatBan <= 2008;
--14: Thống kê số đầu sách của mỗi nhà xuất bản
SELECT TenNhaXuatBan, COUNT(MaSach) SoDauSach 
FROM Books B JOIN Publishers P ON P.MaNhaXuatBan = B.MaNhaXuatBan 
GROUP BY P.TenNhaXuatBan;
--15: Thống kê số đầu sách của mỗi loại sách
SELECT TenLoaiSach, COUNT(MaSach) SoLuong
FROM Books B JOIN BookTypes T ON T.MaLoaiSach = B.MaLoaiSach
GROUP BY TenLoaiSach;
--16: Đặt chỉ mục cho trường tên sách
CREATE INDEX ID_TenSach ON Books(TenSach);
--17: Viết view lấy thông tin mã sách, tên sách, tác giả, nhà xuất bản và giá bán 
CREATE VIEW ThongTin AS
SELECT MaSach, TenSach, TacGia, TenNhaXuatBan, GiaBan
FROM Books B JOIN Publishers P ON B.MaNhaXuatBan = P.MaNhaXuatBan;
--18: Viết store procedure 
--SP_Them_Sach: thêm mới một cuốn sách
CREATE PROC SP_Them_Sach 
@MaSach NVARCHAR(255), @TenSach NVARCHAR(255), 
@TacGia NVARCHAR(255), @NoiDungTomTat NVARCHAR(MAX), 
@NamXuatBan INT, @LanXuatBan INT, 
@GiaBan INT, @SoLuong INT, 
@MaNhaXuatBan INT, @MaLoaiSach INT
AS
BEGIN
	INSERT INTO Books (MaSach, TenSach, TacGia, NoiDungTomTat, NamXuatBan, LanXuatBan, GiaBan, SoLuong, MaNhaXuatBan, MaLoaiSach)
	VALUES (@MaSach, @TenSach, @TacGia, @NoiDungTomTat, @NamXuatBan, @LanXuatBan, @GiaBan, @SoLuong, @MaNhaXuatBan, @MaLoaiSach);
END;
EXEC SP_Them_Sach N'B004', N'Giải tích', N'Nguyễn Văn C', N'Cuốn sách giới thiệu các khái niệm và phương pháp giải quyết bài toán trong giải tích.', 2012, 1, 100000, 60, 2, 2;
--SP_Tim_Sach: Tìm sách theo từ khóa
CREATE PROC SP_Tim_Sach @TuKhoa NVARCHAR(255)
AS
BEGIN
	SELECT * FROM Books WHERE TenSach LIKE N'%' + @TuKhoa + N'%';
END;
EXEC SP_Tim_Sach N'tích';
--SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục
CREATE PROC SP_Sach_ChuyenMuc @MaLoaiSach INT
AS
BEGIN
    SELECT *
    FROM Books
    WHERE MaLoaiSach = @MaLoaiSach;
END;
EXEC SP_Sach_ChuyenMuc 2;
