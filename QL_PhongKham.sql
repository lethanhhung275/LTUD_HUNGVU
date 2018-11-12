
create database QL_PhongKham
create table BacSi
(
	sttBS	int primary key identity(1,1),
	tenBS	nvarchar(100),
	username	varchar(50),
	password	varchar(50),
	DiaChi		nvarchar(200),
	DienThoai	float
)

create table BenhNhan
(
	sttBN	int primary key,
	hoten	nvarchar(50),
	CMND	int,
	diachi	nvarchar(100),
	gioitinh	nvarchar(3),
	ngaykham	datetime,
	BSphutrach	int, constraint fk_BenhNhan_BacSi foreign key(BSphutrach) references BacSi(sttBS)
)

create table BenhNhanThuong
(
	sttBNT	int primary key identity(1,1),
	sttBN	int, constraint fk_BenhNhanThuong_BenhNhan foreign key(sttBN) references BenhNhan(sttBN)
)

create table BenhNhanNamGiuong_ChuaXepCho
(
	sttBNNG_CXC	int primary key identity(1,1),
	sttBN	int, constraint fk_BenhNhanNamGiuong_ChuaXepCho_BenhNhan foreign key(sttBN) references BenhNhan(sttBN)
)

create table GiuongBenh
(
	sttGB	int primary key identity(1,1),
	tinhtrang	nvarchar(20)
)

create table BenhNhanNamGiuong_DaXepCho
(
	sttBNNG_DXC	int primary key identity(1,1),
	sttBN	int,constraint fk_BenhNhanNamGiuong_DaXepCho_BenhNhan foreign key(sttBN) references BenhNhan(sttBN),
	sttGB	int, constraint fk_BenhNhanNamGiuong_DaXepCho_GiuongBenh foreign key(sttGB) references GiuongBenh(sttGB),
	ngayxep		datetime
)

create table DonThuoc
(
	sttDT	int primary key,
	TenThuoc	nvarchar(300),
	NgayCapThuoc	datetime,
	TienThuoc	int
)

--drop table DonThuoc_BenhNhanThuong
create table DonThuoc_BenhNhanThuong
(
	sttDT_BNT	int primary key identity(1,1),
	sttDT	int,constraint fk_DonThuoc_DonThuoc_BenhNhanThuong foreign key(sttDT) references DonThuoc(sttDT),
	MaBenhNhanThuong	int,constraint fk_DonThuoc_BenhNhanThuong foreign key(MaBenhNhanThuong) references BenhNhanThuong(sttBNT)	
)

create table DonThuoc_BenhNhanNamGiuong_DaXepCho
(
	sttDT_BNNG_DXC	int primary key identity(1,1),
	sttDT	int,constraint fk_DonThuoc_DonThuoc_BenhNhanNamGiuong_DaXepCho foreign key(sttDT) references DonThuoc(sttDT),
	MaBenhNhanNamGiuong_DaXepCho int, constraint fk_DonThuoc_BenhNhanNamGiuong_DaXepCho_BenhNhanNamGiuong_DaXepCho foreign key(MaBenhNhanNamGiuong_DaXepCho) references BenhNhanNamGiuong_DaXepCho(sttBNNG_DXC),	
	TinhTrang	nvarchar(20)
)

create table ThamSo
(
	sttTS	int primary key identity(1,1),
	Tien1Ngay1Giuong	float
)

create table HoaDon
(
	sttHD	int primary key identity(1,1),
	sttBNNG_DXC int, constraint fk_HoaDon_BenhNhanNamGiuong_DaXepCho foreign key(sttBNNG_DXC) references BenhNhanNamGiuong_DaXepCho(sttBNNG_DXC),
	ThanhTien	int
)

--------------- insert dữ liệu--------------

insert into BacSi(tenBS,username,password) values(N'Vũ Mạnh Tuấn','vumanhtuan','123456')
insert into BacSi(tenBS,username,password) values(N'Trần Thị Thúy Hằng','tranthithuyhang','123456')
insert into BacSi(tenBS,username,password) values(N'Nguyễn Duy Hoài Nam','nguyenduyhoainam','123456')


insert into BenhNhan values('1',N'Nguyễn Đức Duy','1234567890',N'123 ABC Tân Bình TP.HCM','Nam',getdate(),'1')
insert into BenhNhan values('7',N'Nguyễn Đức Duy Anh','1234567890',N'123 ABC Tân Bình TP.HCM','Nam',getdate(),'3')
insert into BenhNhan values('2',N'Trần Thị Phương Anh','1563232890',N'456 CDE Tân Bình TP.HCM',N'Nữ',getdate(),'2')
insert into BenhNhan values('3',N'Nguyễn Cao Cường','1542232890',N'576 CFGE Tân Bình TP.HCM','Nam',getdate(),'1')
insert into BenhNhan values('4',N'Nguyễn Trần Anh Đức','1586732890',N'341/43F HGHG Q3 TP.HCM','Nam',getdate(),'2')


insert into BenhNhanThuong(sttBN) values('1')
insert into BenhNhanThuong(sttBN) values('2')

insert into GiuongBenh(tinhtrang) values(N'Có bệnh nhân')
insert into GiuongBenh(tinhtrang) values(N'Còn Trống')

insert into BenhNhanNamGiuong_DaXepCho(sttBN,sttGB,ngayxep) values('3','1',getdate())
insert into BenhNhanNamGiuong_DaXepCho(sttBN,sttGB,ngayxep) values('3','2',getdate())

insert into ThamSo(Tien1Ngay1Giuong) values ('50000')