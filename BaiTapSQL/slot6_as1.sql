create database slot_6
go
use slot_6
create schema orders;
create schema customers;
create schema products;
create table orders.orderi(
	order_id int not null primary key,
	customer_id int not null,
	day_acquire date not null,
	foreign key (customer_id) references customers.customer (customer_id),
);
create table customers.customer(
	customer_id int not null primary key,
	customer_name nvarchar(100) not null,
	customer_address nvarchar(100) not null,
	customer_tel varchar(10) not null
);
create table orders.order_detail(
	order_id int not null,
	product_id int not null,
	quantity int not null,
	primary key (order_id, product_id),
	foreign key (product_id) references products.product (product_id),
	foreign key (order_id) references orders.orderi (order_id)
);
create table products.product(
	product_id int primary key not null,
	product_name nvarchar(100) not null,
	product_description nvarchar(100) not null,
	product_donvi nvarchar(10) not null,
	product_price int not null
);

insert into products.product (product_id,product_name,product_description,product_donvi,product_price) 
values (1, 'Máy tính T450', 'Máy nhập mới', 'Chiếc', 1000);
insert into products.product (product_id,product_name,product_description,product_donvi,product_price) 
values (2, 'Điện thoại Nokia5670', 'Điện thoại đang hot', 'Chiếc', 200),(3, 'Máy in Samsung 450', 'Máy in đang ế', 'Chiếc', 100);
insert into customers.customer values (1, 'Nguyễn Văn An', '111 Nguyễn Trãi, Thanh Xuân, Hà Nội', '987654321');
insert into customers.customer values (2, 'Nguyễn Văn Bình', '8 Nguyễn Trãi, Thanh Xuân, Hà Nội', '087654321');
insert into orders.orderi values (123, 1, '11-18-09');
insert into orders.order_detail values (123, 1, 1),(123, 2, 2), (123, 3, 1);
insert into orders.order_detail values (1, 1, 2),(1, 2, 3), (1, 3, 2);
--4a: Danh sách khách hàng đã mua hàng 
select customer_name Ten_khach_hang, customer_address Dia_chi, customer_tel Dien_thoai
from customers.customer order by Ten_khach_hang asc;
--4b:Danh sách sản phẩm của cửa hàng
select product_name Ten_san_pham, product_description Mo_ta, product_price Gia, product_donvi Don_vi
from products.product order by Gia desc;
--4c: Danh sách đơn đặt hàng của cửa hàng
select * from orders.orderi;
--5a: Liệt kê danh sách khách hàng theo thứ tự alphabet
select customer_name Ten_khach_hang, customer_address Dia_chi, customer_tel Dien_thoai
from customers.customer order by Ten_khach_hang asc;
--5b: Liệt kê danh sách các sản phẩm của cửa hàng theo thứ tự giá giảm dần
select product_name Ten_san_pham, product_description Mo_ta, product_price Gia, product_donvi Don_vi
from products.product order by Gia desc;
--5c: Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua
select product_name Ten_san_pham, product_description Mo_ta, product_price Gia, product_donvi Don_vi
from products.product p 
join orders.order_detail od on od.product_id = p.product_id
join orders.orderi oi on oi.order_id = od.order_id
join customers.customer c on c.customer_id = oi.customer_id
where c.customer_name = 'Nguyễn Văn An';
--6a: Số khách hàng đã mua tại cửa hàng
select COUNT(customer_id) So_Khach_Hang from customers.customer;
--6b: Số mặt hàng mà cửa hàng bán
select COUNT(product_id) So_Mat_Hang from products.product;
--6c: Tổng tiền của từng đơn hàng
SELECT oi.order_id, SUM(p.product_price * od.quantity) AS TotalPrice
FROM orders.orderi oi
JOIN orders.order_detail od ON oi.order_id = od.order_id
JOIN products.product p ON od.product_id = p.product_id
GROUP BY oi.order_id;
--7a: Trường giá tiền >0
UPDATE products.product
SET product_price = 1
WHERE product_price <= 0;
ALTER TABLE products.product ADD CONSTRAINT Check_Price CHECK (product_price >0);
--7b: Thay đổi ngày đặt hàng nhỏ hơn ngày hiện tại
UPDATE orders.orderi
SET day_acquire = DATEADD(day, -1, CAST(GETDATE() AS date))
WHERE day_acquire >= CAST(GETDATE() AS date);
ALTER TABLE orders.orderi ADD CONSTRAINT Check_DayAcquire CHECK (day_acquire < GETDATE());
--7c: Thêm trường ngày xuất hiện của sản phẩm
ALTER TABLE products.product
ADD product_launch_date date;
--8a: Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên các cột này
CREATE INDEX idx_product_name ON products.product (product_name);
CREATE INDEX idx_customer_name ON customers.customer (customer_name);
--8b: Xây dựng các view
--View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
CREATE VIEW View_KhachHang AS
SELECT customer_name AS 'Tên khách hàng', customer_address AS 'Địa chỉ', customer_tel AS 'Điện thoại'
FROM customers.customer;
-- View_SanPham với các cột: Tên sản phẩm, Giá bán
CREATE VIEW View_SanPham AS
SELECT product_name AS 'Tên sản phẩm', product_price AS 'Giá bán'
FROM products.product;
--View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản phẩm, Số lượng, Ngày mua
CREATE VIEW View_KhachHang_SanPham AS
SELECT c.customer_name AS 'Tên khách hàng', c.customer_tel AS 'Số điện thoại', p.product_name AS 'Tên sản phẩm', od.quantity AS 'Số lượng', oi.day_acquire AS 'Ngày mua'
FROM customers.customer c
JOIN orders.orderi oi ON c.customer_id = oi.customer_id
JOIN orders.order_detail od ON oi.order_id = od.order_id
JOIN products.product p ON od.product_id = p.product_id;
--Viết các Store Procedure
--SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng 
CREATE PROCEDURE SP_TimKH_MaKH @MaKH int
AS
BEGIN
    SELECT *
    FROM customers.customer
    WHERE customer_id = @MaKH;
END;
--SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
CREATE PROCEDURE SP_TimKH_MaHD @MaHD int
AS
BEGIN
    SELECT c.*
    FROM customers.customer c
    JOIN orders.orderi oi ON c.customer_id = oi.customer_id
    WHERE oi.order_id = @MaHD;
END;
--SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store.CREATE PROCEDURE SP_SanPham_MaKH @MaKH int
AS
BEGIN
    SELECT p.*
    FROM products.product p
    JOIN orders.order_detail od ON p.product_id = od.product_id
    JOIN orders.orderi oi ON od.order_id = oi.order_id
    WHERE oi.customer_id = @MaKH;
END;

