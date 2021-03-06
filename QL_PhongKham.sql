-- tao database
create database QL_PhongKham
go
-- chuyen sang QL_PhongKham
use QL_PhongKham
go
-- tao bang bac si
create table BacSi
(
	sttBS	int primary key identity(1,1),
	tenBS	nvarchar(100),
	username	varchar(50),
	password	varchar(50),
	DiaChi		nvarchar(200),
	DienThoai	varchar(11)
)
go
-- tao bang benh nhan
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
go
-- tao bang benh nhan thuong
create table BenhNhanThuong
(
	sttBNT	int primary key identity(1,1),
	sttBN	int, constraint fk_BenhNhanThuong_BenhNhan foreign key(sttBN) references BenhNhan(sttBN)
) 
go
-- tao bang benh nhan nam giuong chua xep cho
create table BenhNhanNamGiuong_ChuaXepCho
(
	sttBNNG_CXC	int primary key identity(1,1),
	sttBN	int, constraint fk_BenhNhanNamGiuong_ChuaXepCho_BenhNhan foreign key(sttBN) references BenhNhan(sttBN)
)
go
-- tao bang giuong benh
create table GiuongBenh
(
	sttGB	int primary key identity(1,1),
	tinhtrang	nvarchar(20)
)
go
-- tao bang benh nhan nam giuong da xep cho
create table BenhNhanNamGiuong_DaXepCho
(
	sttBNNG_DXC	int primary key identity(1,1),
	sttBN	int,constraint fk_BenhNhanNamGiuong_DaXepCho_BenhNhan foreign key(sttBN) references BenhNhan(sttBN),
	sttGB	int, constraint fk_BenhNhanNamGiuong_DaXepCho_GiuongBenh foreign key(sttGB) references GiuongBenh(sttGB),
	ngayxep		datetime
)
go
-- tao bang don thuoc
create table DonThuoc
(
	sttDT	int primary key,
	TenThuoc	nvarchar(300),
	NgayCapThuoc	datetime,
	TienThuoc	int
)
go
-- tao bang don thuoc benh nhan thuong
create table DonThuoc_BenhNhanThuong
(
	sttDT_BNT	int primary key identity(1,1),
	sttDT	int,constraint fk_DonThuoc_DonThuoc_BenhNhanThuong foreign key(sttDT) references DonThuoc(sttDT),
	MaBenhNhanThuong	int,constraint fk_DonThuoc_BenhNhanThuong foreign key(MaBenhNhanThuong) references BenhNhanThuong(sttBNT)	
)
go
-- tao bang don thuoc benh nhan nam giuong da xep cho
create table DonThuoc_BenhNhanNamGiuong_DaXepCho
(
	sttDT_BNNG_DXC	int primary key identity(1,1),
	sttDT	int,constraint fk_DonThuoc_DonThuoc_BenhNhanNamGiuong_DaXepCho foreign key(sttDT) references DonThuoc(sttDT),
	MaBenhNhanNamGiuong_DaXepCho int, constraint fk_DonThuoc_BenhNhanNamGiuong_DaXepCho_BenhNhanNamGiuong_DaXepCho foreign key(MaBenhNhanNamGiuong_DaXepCho) references BenhNhanNamGiuong_DaXepCho(sttBNNG_DXC),	
	TinhTrang	nvarchar(20)
)
go
-- tao bang tham so
create table ThamSo
(
	sttTS	int primary key identity(1,1),
	Tien1Ngay1Giuong	float
)
go
-- tao bang hoa don
create table HoaDon
(
	sttHD	int primary key identity(1,1),
	sttBNNG_DXC int, constraint fk_HoaDon_BenhNhanNamGiuong_DaXepCho foreign key(sttBNNG_DXC) references BenhNhanNamGiuong_DaXepCho(sttBNNG_DXC),
	ThanhTien	int
)

---------------Store Proc--------------
go
--insert bệnh nhân đồng thời insert bệnh nhân thường
create proc sp_InsertBenhNhan_BenhNhanThuong
@hoten	nvarchar(50),
@CMND	int,
@diachi	nvarchar(100),
@gioitinh	nvarchar(3),
@ngaykham	datetime,
@BSphutrach	int
as
begin
	declare @sttBN	int
	set @sttBN=1
	
	while exists(select * from BenhNhan where sttBN=@sttBN)
		begin
			set @sttBN=@sttBN+1
		end
	set dateformat dmy
	insert into BenhNhan values(@sttBN,@hoten,@CMND,@diachi,@gioitinh,@ngaykham,@BSphutrach)
	insert into BenhNhanThuong(sttBN) values(@sttBN)
end
go
--insert bệnh nhân đồng thời insert bệnh nhân nằm giường chưa xếp chỗ
create proc sp_InsertBenhNhan_BenhNhanNamGiuong_ChuaXepCho
@hoten	nvarchar(50),
@CMND	int,
@diachi	nvarchar(100),
@gioitinh	nvarchar(3),
@ngaykham	datetime,
@BSphutrach	int
as
begin
	declare @sttBN	int
	set @sttBN=1
	
	while exists(select * from BenhNhan where sttBN=@sttBN)
		begin
			set @sttBN=@sttBN+1
		end
	set dateformat dmy
	insert into BenhNhan values(@sttBN,@hoten,@CMND,@diachi,@gioitinh,@ngaykham,@BSphutrach)
	insert into BenhNhanNamGiuong_ChuaXepCho(sttBN) values(@sttBN)
end
go
--insert bệnh nhân nằm giường đã xếp chỗ đồng thời xóa dữ liệu bệnh nhân đó tại bảng bệnh nhân nằm giường chưa xếp chỗ
-- và cập nhật tình trạng của giường bệnh nơi mà bệnh nhân được xếp nằm là có bệnh nhân.
create proc sp_InsertBenhNhanNamGiuong_DaXepCho
@sttBN	int,
@sttGB	int,
@ngayxep	datetime
as
begin
	set dateformat dmy
	insert BenhNhanNamGiuong_DaXepCho(sttBN,sttGB,ngayxep) values(@sttBN,@sttGB,@ngayxep)
	delete BenhNhanNamGiuong_ChuaXepCho where sttBN=@sttBN
	update GiuongBenh	set tinhtrang=N'Có bệnh nhân' where sttGB=@sttGB
end
go
--Cập nhật thông tin bệnh nhân
create proc sp_UpdateThongTinBenhNhan
@sttBN	int,
@hoten	nvarchar(50),
@CMND	int,
@diachi	nvarchar(100),
@gioitinh	nvarchar(3),
@ngaykham	datetime,
@BSphutrach	int
as
begin
	if not exists(select * from BenhNhan where sttBN=@sttBN)
		begin
			print N'Không tồn tại bệnh nhân này'
			return
		end
	else
		begin
			set dateformat dmy
			update BenhNhan set hoten=@hoten,CMND=@CMND,diachi=@diachi,gioitinh=@gioitinh,ngaykham=@ngaykham,BSphutrach=@BSphutrach
			where sttBN=@sttBN
		end
end
go
--Insert bác sĩ mới
create proc sp_InsertBacSi
@tenBS	nvarchar(100),
@username	varchar(50),
@password	varchar(50),
@DiaChi		nvarchar(200),
@DienThoai	varchar(11)
as
begin
	insert into BacSi(tenBS,username,password,DiaChi,DienThoai) values(@tenBS,@username,@password,@DiaChi,@DienThoai)
end
go
--Lấy danh sách bác sĩ--
create proc sp_SelectAllBacSi
as
begin
	select * from BacSi
end
go
--Lấy danh sách bác sĩ cho tra cứu
create proc sp_SelectAllBacSiForTraCuu
as
begin
	select sttBS,tenBS,DiaChi,DienThoai
	from BacSi
end
go
--Lấy bác sĩ theo username và password
create proc sp_SelectBacSiByUserNameandPassword
@username	varchar(50),
@password	varchar(50)
as
begin
	select * from BacSi where username=@username and password=@password
end
go
--Thay đổi mật khẩu bác sĩ
create proc sp_UpdatePassWord
@sttBS	int,
@password	varchar(50)
as
begin
	if not exists(select * from BacSi where sttBS=@sttBS)
		begin
			print N'Không tồn tại bác sĩ yêu cầu'
			return;
		end
	else
		begin
			update BacSi set password=@password where sttBS=@sttBS
		end
end
go
--Thay đổi thông tin cá nhân bác sĩ
create proc sp_UpdateThongTinBacSi
@sttBS		int,
@DienThoai	varchar(11),
@DiaChi		nvarchar(50)
as
begin
	if not exists(select * from BacSi where sttBS=@sttBS)
		begin
			print N'Không tồn tại bác sĩ này'
			return;
		end
	else
		begin
			update BacSi set DienThoai=@DienThoai,DiaChi=@DiaChi where sttBS=@sttBS
		end
end
go
--Lấy danh sách bệnh nhân nằm giường chưa được xếp chỗ 
create proc sp_selectAllBenhNhanNamGiuong_ChuaXepCho
as
begin
	select  bnng_cxc.sttBN as N'Mã Bệnh Nhân', bn.hoten as N'Họ Tên Bệnh Nhân', bn.CMND as N'Số Chứng Minh Nhân Dân', bn.diachi as N'Địa Chỉ', bs.sttBS, bs.tenBS as N'Bác Sĩ Điều Trị'
	from	BenhNhanNamGiuong_ChuaXepCho bnng_cxc,BenhNhan bn,BacSi bs
	where	bnng_cxc.sttBN=bn.sttBN and bs.sttBS=bn.BSphutrach
end
go
--Lấy dah sách bệnh nhân nằm giường đã xếp chỗ
create proc sp_selectAllBenhNhanNamGiuong_DaXepCho
as
begin
	select  bnng_dxc.sttBNNG_DXC, bnng_dxc.sttBN as N'Mã Bệnh Nhân', bn.hoten as N'Họ Tên Bệnh Nhân', bn.CMND as N'Số Chứng Minh Nhân Dân', bn.diachi as N'Địa Chỉ', bs.sttBS, bs.tenBS as N'Bác Sĩ Điều Trị',bnng_dxc.sttGB as N'Giường',bnng_dxc.ngayxep as N'Ngày xếp'
	from	BenhNhanNamGiuong_DaXepCho bnng_dxc,BenhNhan bn,BacSi bs
	where	bnng_dxc.sttBN=bn.sttBN and bs.sttBS=bn.BSphutrach
end
go
--Lấy danh sách bệnh nhân
create proc sp_SelectAllBenhNhan
as
begin
	select sttBN as N'Mã Bệnh Nhân',hoten as N'Họ Tên Bệnh Nhân',CMND,diachi as N'Địa Chỉ',ngaykham as N'Ngày Khám Bệnh',BSphutrach as N'Bác Sĩ Điều Trị',gioitinh as N'Giới Tính'
	from BenhNhan
end
go
--Lấy danh sách bệnh nhân thường
create proc sp_SelectAllBenhNhanThuong
as
begin
	select  bnt.sttBNT, bnt.sttBN as N'Mã Bệnh Nhân', bn.hoten as N'Họ Tên Bệnh Nhân', bn.CMND as N'Số Chứng Minh Nhân Dân', bn.diachi as N'Địa Chỉ', bs.sttBS, bs.tenBS as N'Bác Sĩ Điều Trị'
	from	BenhNhanThuong bnt,BenhNhan bn,BacSi bs
	where	bnt.sttBN=bn.sttBN and bs.sttBS=bn.BSphutrach
end
go
--Lấy thông tin bệnh nhân theo tên bệnh nhân
create proc sp_SelectAllBenhNhanByHoTen

@hoten	nvarchar(50)
as
begin
	select sttBN as N'Mã Bệnh Nhân',hoten as N'Họ Tên Bệnh Nhân',CMND,diachi as N'Địa Chỉ',ngaykham as N'Ngày Khám Bệnh',BSphutrach as N'Bác Sĩ Điều Trị',gioitinh as N'Giới Tính'
	from BenhNhan
	where hoten=@hoten
end
go
--Lấy thông tin bệnh nhân theo Bác sĩ điều trị
create proc sp_SelectAllBenhNhanByBacSiDieuTri
@sttBS int
as
begin
	select sttBN as N'Mã Bệnh Nhân',hoten as N'Họ Tên Bệnh Nhân',CMND,diachi as N'Địa Chỉ',ngaykham as N'Ngày Khám Bệnh',BSphutrach as N'Bác Sĩ Điều Trị',gioitinh as N'Giới Tính'
	from BenhNhan
	where BSphutrach=@sttBS
end
go
--Lấy thông tin bệnh nhân theo Bác sĩ điều trị và giới tính
create proc sp_SelectAllBenhNhanByBacSiAndGioiTinh
@sttBS int,
@gioitinh nvarchar(5)
as
begin
	select sttBN as N'Mã Bệnh Nhân',hoten as N'Họ Tên Bệnh Nhân',CMND,diachi as N'Địa Chỉ',ngaykham as N'Ngày Khám Bệnh',BSphutrach as N'Bác Sĩ Điều Trị',gioitinh as N'Giới Tính'
	from BenhNhan
	where BSphutrach=@sttBS and gioitinh=@gioitinh
end
go
--Xóa bệnh nhân nằm giường đã xếp chỗ
create proc sp_DeleteBenhNhanNamGiuong_DaXepCho
@sttBN	int,
@sttGB	int
as
begin
	if not exists(select * from BenhNhanNamGiuong_DaXepCho where sttBN=@sttBN)
		return;
	else
		begin
			delete BenhNhanNamGiuong_DaXepCho where sttBN=@sttBN
			update GiuongBenh set tinhtrang=N'Còn Trống' where sttGB=@sttGB
		end
end
go
--Lấy danh sách những giường bệnh đang có bệnh nhân nằm cùng tên của bệnh nhân đó.
create proc sp_SelectAllGiuongBenh_CoBenhNhan
as
begin

	select bnng_dxc.sttBN,bn.hoten as N'Tên Bệnh Nhân',bnng_dxc.sttGB
	from BenhNhan bn,BenhNhanNamGiuong_DaXepCho bnng_dxc
	where bnng_dxc.sttBN=bn.sttBN

end
go
--Insert Đơn thuốc đồng thời insert đơn thuốc bệnh nhân thường
create proc sp_InsertDonThuoc_DonThuocBenhNhanThuong
@TenThuoc	nvarchar(300),
@TienThuoc	int,
@MaBenhNhanThuong	int
as
begin
	declare @sttDT int
	set @sttDT=1

	while exists(select * from DonThuoc where sttDT=@sttDT)
		begin
			set @sttDT=@sttDT+1
		end

	insert DonThuoc values(@sttDT,@TenThuoc,getdate(),@TienThuoc)
	insert DonThuoc_BenhNhanThuong(sttDT,MaBenhNhanThuong) values(@sttDT,@MaBenhNhanThuong)
end
go
--Insert Đơn thuốc đồng thời insert đơn thuốc bệnh nhân nằm giường đã xếp chỗ
create proc sp_InsertDonThuoc_DonThuocBenhNhanNamGiuong_DaXepCho
@TenThuoc	nvarchar(300),
@TienThuoc	int,
@MaBenhNhanNamGiuong_DaXepCho	int
as
begin
	declare @sttDT int
	set @sttDT=1

	while exists(select * from DonThuoc where sttDT=@sttDT)
		begin
			set @sttDT=@sttDT+1
		end

	insert DonThuoc values(@sttDT,@TenThuoc,getdate(),@TienThuoc)
	insert DonThuoc_BenhNhanNamGiuong_DaXepCho(sttDT,MaBenhNhanNamGiuong_DaXepCho) values (@sttDT,@MaBenhNhanNamGiuong_DaXepCho)
end
go
--Lấy danh sách đơn thuốc của bệnh nhân nằm giường đã xếp chỗ
create proc sp_selectAllDonThuoc_BenhNhanNamGiuong_DaXepChoByID
@sttBNNG_DXC	int
as
begin

	select dt_bnng_dxc.sttDT as N'Mã Đơn Thuốc',dt_bnng_dxc.MaBenhNhanNamGiuong_DaXepCho as N'Mã Bệnh Nhân',dt.TenThuoc as N'Tên Thuốc',dt.TienThuoc as N'Tiền Thuốc',dt_bnng_dxc.TinhTrang as N'Tình Trạng'
	from DonThuoc_BenhNhanNamGiuong_DaXepCho dt_bnng_dxc,DonThuoc dt
	where MaBenhNhanNamGiuong_DaXepCho=@sttBNNG_DXC and dt.sttDT=dt_bnng_dxc.sttDT and dt_bnng_dxc.TinhTrang=N'Chưa thanh toán'

end
go
--Lấy tham số
create proc sp_selectThamSo
as
begin
	select * from ThamSo
end
go
--Insert bảng hóa đơn
create proc sp_InsertHoaDon
@sttBNNG_DXC int,
@ThanhTien	int
as
begin
	insert into HoaDon(sttBNNG_DXC,ThanhTien) values(@sttBNNG_DXC,@ThanhTien)
end