-- Câu lệnh tạo bảng (DDL)

-- ============================================================
-- Máy 1 (Chi nhánh miền Bắc)
-- Phân vùng  : Miền Bắc
-- Replicated : KHACHHANG       (5,000 dòng)
-- Horizontal : DONHANG_BAC          (333,334 dòng)
--              CHITIETDH_BAC        (833,025 dòng)
-- Vertical   : SANPHAM_INFO         (2,000 dòng)
-- Hybrid     : THANHTOAN_THE_INFO + THANHTOAN_THE_GIATRI  (571,429 dòng)
-- ============================================================

BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'KHACHHANG', 'DONHANG_BAC', 'CHITIETDH_BAC', 'SANPHAM_INFO', 'THANHTOAN_THE_INFO','THANHTOAN_THE_GIATRI'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

CREATE TABLE KHACHHANG (
    MaKH        VARCHAR2(10)   NOT NULL,
    HoTen       NVARCHAR2(100),
    SoDienThoai VARCHAR2(15),
    Email       VARCHAR2(100),
    ThanhPho    NVARCHAR2(100),
    KhuVuc      VARCHAR2(10),
    CONSTRAINT pk_khachhang PRIMARY KEY (MaKH)
);

CREATE TABLE DONHANG_BAC (
    MaDH      VARCHAR2(10)  NOT NULL,
    MaKH      VARCHAR2(10),
    NgayDat   DATE,
    TrangThai VARCHAR2(30),
    KhuVuc    VARCHAR2(10)  DEFAULT 'Bac',
    TongTien  NUMBER(15,0),
    CONSTRAINT pk_donhang_bac PRIMARY KEY (MaDH),
    CONSTRAINT chk_donhang_bac CHECK (KhuVuc = 'Bac')
);

CREATE TABLE CHITIETDH_BAC (
    MaDH      VARCHAR2(10),
    MaSP      VARCHAR2(8),
    SoLuong   NUMBER(5),
    DonGia    NUMBER(15,0),
    ThanhTien NUMBER(15,0),
    CONSTRAINT pk_chitietdh_bac PRIMARY KEY (MaDH, MaSP)
);
CREATE TABLE SANPHAM_INFO (
    MaSP    VARCHAR2(8)    NOT NULL,
    TenSP   NVARCHAR2(200),
    DanhMuc NVARCHAR2(100),
    DonGia  NUMBER(15,0),
    CONSTRAINT pk_sanpham_info PRIMARY KEY (MaSP)
);

CREATE TABLE THANHTOAN_THE_INFO (
    MaDH       VARCHAR2(10),
    LanTT      NUMBER(5),
    PhuongThuc VARCHAR2(20) DEFAULT 'TheNganHang',
    SoLanTra   NUMBER(3),
    CONSTRAINT pk_tt_the_info  PRIMARY KEY (MaDH, LanTT),
    CONSTRAINT chk_tt_the_info CHECK (PhuongThuc = 'TheNganHang')
);

CREATE TABLE THANHTOAN_THE_GIATRI (
    MaDH   VARCHAR2(10),
    LanTT  NUMBER(5),
    SoTien NUMBER(15,0),
    CONSTRAINT pk_tt_the_giatri PRIMARY KEY (MaDH, LanTT)
);

COMMIT;

-- ============================================================
-- Máy 2 (chi nhánh miền Nam)
-- Phân vùng  : Miền Nam
-- Replicated : KHACHHANG       (5,000 dòng)
-- Horizontal : DONHANG_NAM          (333,334 dòng)
--              CHITIETDH_NAM        (832,061 dòng)
-- Vertical   : SANPHAM_KICHTHUOC    (2,000 dòng)
-- Hybrid     : THANHTOAN_CK  (142,857 dong)
-- ============================================================

BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'KHACHHANG', 'DONHANG_NAM', 'CHITIETDH_NAM', 'SANPHAM_KICHTHUOC', 'THANHTOAN_CK'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

CREATE TABLE KHACHHANG (
    MaKH        VARCHAR2(10)   NOT NULL,
    HoTen       NVARCHAR2(100),
    SoDienThoai VARCHAR2(15),
    Email       VARCHAR2(100),
    ThanhPho    NVARCHAR2(100),
    KhuVuc      VARCHAR2(10),
    CONSTRAINT pk_khachhang PRIMARY KEY (MaKH)
);

CREATE TABLE DONHANG_NAM (
    MaDH      VARCHAR2(10)  NOT NULL,
    MaKH      VARCHAR2(10),
    NgayDat   DATE,
    TrangThai VARCHAR2(30),
    KhuVuc    VARCHAR2(10)  DEFAULT 'Nam',
    TongTien  NUMBER(15,0),
    CONSTRAINT pk_donhang_nam PRIMARY KEY (MaDH),
    CONSTRAINT chk_donhang_nam CHECK (KhuVuc = 'Nam')
);

CREATE TABLE CHITIETDH_NAM (
    MaDH      VARCHAR2(10),
    MaSP      VARCHAR2(8),
    SoLuong   NUMBER(5),
    DonGia    NUMBER(15,0),
    ThanhTien NUMBER(15,0),
    CONSTRAINT pk_chitietdh_nam PRIMARY KEY (MaDH, MaSP)
);
CREATE TABLE SANPHAM_KICHTHUOC (
    MaSP        VARCHAR2(8) NOT NULL,
    KhoiLuong_g NUMBER(10,2),
    Dai_cm      NUMBER(8,2),
    CONSTRAINT pk_sanpham_kt PRIMARY KEY (MaSP)
);

CREATE TABLE THANHTOAN_CK (
    MaDH       VARCHAR2(10),
    LanTT      NUMBER(5),
    PhuongThuc VARCHAR2(20) DEFAULT 'ChuyenKhoan',
    SoTien     NUMBER(15,0),
    SoLanTra   NUMBER(3),
    CONSTRAINT pk_tt_ck  PRIMARY KEY (MaDH, LanTT),
    CONSTRAINT chk_tt_ck CHECK (PhuongThuc = 'ChuyenKhoan')
);

COMMIT;

-- ============================================================
-- Máy 3 (chi nhánh miền Trung)
-- Phân vùng  : Miền Trung
-- Replicated : KHACHHANG       (5,000 dòng)
-- Horizontal : DONHANG_TRUNG        (333,332 dòng)
--              CHITIETDH_TRUNG      (833,207 dòng)
-- Vertical   : SANPHAM_KICHTHUOC2   (2,000 dòng)
-- Hybrid     : THANHTOAN_KHAC  (285,714 dòng)
-- ============================================================

BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'KHACHHANG', 'DONHANG_TRUNG', 'CHITIETDH_TRUNG', 'SANPHAM_KICHTHUOC2', 'THANHTOAN_KHAC'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

CREATE TABLE KHACHHANG (
    MaKH        VARCHAR2(10)   NOT NULL,
    HoTen       NVARCHAR2(100),
    SoDienThoai VARCHAR2(15),
    Email       VARCHAR2(100),
    ThanhPho    NVARCHAR2(100),
    KhuVuc      VARCHAR2(10),
    CONSTRAINT pk_khachhang PRIMARY KEY (MaKH)
);

CREATE TABLE DONHANG_TRUNG (
    MaDH      VARCHAR2(10)  NOT NULL,
    MaKH      VARCHAR2(10),
    NgayDat   DATE,
    TrangThai VARCHAR2(30),
    KhuVuc    VARCHAR2(10)  DEFAULT 'Trung',
    TongTien  NUMBER(15,0),
    CONSTRAINT pk_donhang_trung PRIMARY KEY (MaDH),
    CONSTRAINT chk_donhang_trung CHECK (KhuVuc = 'Trung')
);

CREATE TABLE CHITIETDH_TRUNG (
    MaDH      VARCHAR2(10),
    MaSP      VARCHAR2(8),
    SoLuong   NUMBER(5),
    DonGia    NUMBER(15,0),
    ThanhTien NUMBER(15,0),
    CONSTRAINT pk_chitietdh_trung PRIMARY KEY (MaDH, MaSP)
);
CREATE TABLE SANPHAM_KICHTHUOC2 (
    MaSP    VARCHAR2(8) NOT NULL,
    Cao_cm  NUMBER(8,2),
    Rong_cm NUMBER(8,2),
    CONSTRAINT pk_sanpham_kt2 PRIMARY KEY (MaSP)
);

CREATE TABLE THANHTOAN_KHAC (
    MaDH       VARCHAR2(10),
    LanTT      NUMBER(5),
    PhuongThuc VARCHAR2(20),
    SoTien     NUMBER(15,0),
    SoLanTra   NUMBER(3),
    CONSTRAINT pk_tt_khac  PRIMARY KEY (MaDH, LanTT),
    CONSTRAINT chk_tt_khac CHECK (PhuongThuc IN ('TienMat','ViDienTu'))
);

COMMIT;

-- 10 câu truy vấn phân tán (distributed queries)
-- Câu truy vấn 1: Thống kê tổng số đơn hàng trên cả 3 khu vực và đếm số đơn hàng theo từng KHUVUC Bắc - Trung - Nam
SELECT
   (SELECT COUNT(*) FROM DONHANG_BAC) +
   (SELECT COUNT(*) FROM MAY2_OWNER.DONHANG_NAM@BTL1_LINK_M02) +
   (SELECT COUNT(*) FROM MAY3.DONHANG_TRUNG@BTL1_LINK_M03)
   AS TONG_SO_DONHANG
FROM DUAL;

-- Câu truy vấn 2: INTERSECT Tìm những sản phẩm (MaSP) được mua ở cả miền Bắc và miền Trung
SELECT MaSP FROM CHITIETDH_BAC
INTERSECT
SELECT MaSP FROM MAY3.CHITIETDH_TRUNG@BTL1_LINK_M03;

-- Câu truy vấn 3: MINUS Tìm những khách hàng ở Hà Nội (ThanhPho) nhưng chưa từng có đơn hàng nào ở miền Bắc
SELECT MaKH FROM KHACHHANG WHERE ThanhPho = 'Hà Nội'
MINUS
SELECT MaKH FROM MAY3.DONHANG_TRUNG@BTL1_LINK_M03;

-- Câu truy vấn 4: MINUS Tìm các sản phẩm (MaSP) thuộc danh mục 'Thú cưng' nhưng chưa từng được bán ở miền Bắc và miền Nam
SELECT MaSP FROM SANPHAM_INFO
WHERE DanhMuc = 'Thú cưng'
MINUS
(
    SELECT MaSP FROM CHITIETDH_BAC
    UNION
    SELECT MaSP FROM MAY2_OWNER.CHITIETDH_NAM@BTL1_LINK_M02
);

-- Câu truy vấn 5: DIVISION Tìm khách hàng đã mua tất cả các loại danh mục sản phẩm (DanhMuc) hiện có ở chi nhanh Bắc, Nam
SELECT KH.MaKH, KH.ThanhPho
FROM KHACHHANG KH
WHERE NOT EXISTS (
    SELECT SP.DanhMuc FROM SANPHAM_INFO SP
    WHERE NOT EXISTS (
        SELECT i.MaDH
        FROM (SELECT MaDH, MaSP FROM CHITIETDH_BAC
              UNION SELECT MaDH, MaSP FROM MAY2_OWNER.CHITIETDH_NAM@BTL1_LINK_M02) i
        JOIN (SELECT MaDH, MaKH FROM DONHANG_BAC
              UNION SELECT MaDH, MaKH FROM MAY2_OWNER.DONHANG_NAM@BTL1_LINK_M02) o 
        ON i.MaDH = o.MaDH
        JOIN SANPHAM_INFO SP2 ON i.MaSP = SP2.MaSP
        WHERE o.MaKH = KH.MaKH AND SP2.DanhMuc = SP.DanhMuc
    )
);

-- Câu truy vấn 6: SUM & GROUP BY Tính tổng doanh thu của từng danh mục sản phẩm
SELECT SP.DanhMuc, CT.ThanhTien
FROM SANPHAM_INFO SP
JOIN CHITIETDH_BAC CT ON SP.MaSP = CT.MaSP
GROUP BY SP.DanhMuc, CT.ThanhTien;

-- Câu truy vấn 7: AVG & HAVING Tìm các khách hàng ở miền Nam có thành tiền đơn hàng lớn hơn 1000000
SELECT KH.MaKH, KH.HoTen, ThanhTien
FROM KHACHHANG KH
JOIN MAY2_OWNER.DONHANG_NAM@BTL1_LINK_M02 DH ON KH.MaKH = DH.MaKH
JOIN MAY2_OWNER.CHITIETDH_NAM@BTL1_LINK_M02 CT ON DH.MaDH = CT.MaDH
WHERE ThanhTien > 10000000;

-- Câu truy vấn 8: COUNT Đếm số lượng đơn hàng thanh toán bằng thẻ tín dụng có số kỳ trả góp trên 6
SELECT COUNT(inf.MaDH) as SoLuongThanhToanThe
FROM THANHTOAN_THE_INFO inf
JOIN MAY2_OWNER.THANHTOAN_CK@BTL1_LINK_M02 CK ON inf.MaDH = CK.MaDH AND inf.MaDH = CK.MaDH
WHERE inf.LanTT > 6;

-- Câu truy vấn 9: MAX Tìm chiều cao lớn nhất của sản phẩm theo từng loại (DanhMuc)
SELECT SP1.DanhMuc, MAX(SPKT3.Cao_CM) as ChieuCaoToiDa
FROM SANPHAM_INFO SP1
JOIN may3.SANPHAM_KICHTHUOC2@BTL1_LINK_M03 SPKT3 ON SP1.MaSP = SPKT3.MaSP
GROUP BY SP1.DanhMuc;

-- Câu truy vấn 10: Complex Join Liệt kê thông tin đơn hàng miền Trung gồm: Tên thành phố khách hàng, tên danh mục sản phẩm và tổng tiền thanh toán
SELECT KH.ThanhPho, SP.DanhMuc, TTK.SoTien
FROM may3.DONHANG_TRUNG@BTL1_LINK_M03 DH
JOIN KHACHHANG KH ON KH.MaKH = DH.MaKH
JOIN may3.CHITIETDH_TRUNG@BTL1_LINK_M03 CT ON DH.MaDH = CT.MaDH
JOIN SANPHAM_INFO SP ON CT.MaSP = SP.MaSP
JOIN may3.THANHTOAN_KHAC@BTL1_LINK_M03 TTK ON DH.MaDH = TTK.MaDH;


