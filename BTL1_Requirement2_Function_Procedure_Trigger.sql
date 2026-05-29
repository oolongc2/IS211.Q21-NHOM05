--------------------------FUNCTION
-- MÁY 1
-- ============================================================
CREATE OR REPLACE FUNCTION FN_TONG_SOLUONG_SP_KH_M1 (
    p_MaKH IN VARCHAR2
)
RETURN NUMBER
AS
    v_TongSL NUMBER := 0;
BEGIN
    IF p_MaKH IS NULL THEN
        RETURN 0;
    END IF;

    SELECT NVL(SUM(SoLuong), 0)
    INTO v_TongSL
    FROM (
        SELECT c.SoLuong
        FROM MAY1_OWNER.CHITIETDH_BAC c
        JOIN MAY1_OWNER.DONHANG_BAC d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM MAY2_OWNER.CHITIETDH_NAM@M2_LINK c
        JOIN MAY2_OWNER.DONHANG_NAM@M2_LINK d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM MAY3_OWNER.CHITIETDH_TRUNG@M3_LINK c
        JOIN MAY3_OWNER.DONHANG_TRUNG@M3_LINK d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH
    );

    RETURN v_TongSL;
END;
/
--5 test case máy 1:
-- TC1: Khách hàng có dữ liệu thực tế
SELECT FN_TONG_SOLUONG_SP_KH_M1('KH01844') AS TongSL FROM dual;

-- TC2: Khách hàng khác có thể có đơn
SELECT FN_TONG_SOLUONG_SP_KH_M1('KH00001') AS TongSL FROM dual;

-- TC3: Khách hàng tồn tại nhưng có thể không có đơn
SELECT FN_TONG_SOLUONG_SP_KH_M1('KH05000') AS TongSL FROM dual;

-- TC4: Khách hàng không tồn tại
SELECT FN_TONG_SOLUONG_SP_KH_M1('KH99999') AS TongSL FROM dual;

-- TC5: Dữ liệu NULL
SELECT FN_TONG_SOLUONG_SP_KH_M1(NULL) AS TongSL FROM dual;

-- ============================================================
-- MÁY 2
-- ============================================================
CREATE OR REPLACE FUNCTION FN_TONG_SOLUONG_SP_KH_M2 (
    p_MaKH IN VARCHAR2
)
RETURN NUMBER
AS
    v_TongSL NUMBER := 0;
BEGIN
    IF p_MaKH IS NULL THEN
        RETURN 0;
    END IF;

    SELECT NVL(SUM(SoLuong), 0)
    INTO v_TongSL
    FROM (
        SELECT c.SoLuong
        FROM MAY2_OWNER.CHITIETDH_NAM c
        JOIN MAY2_OWNER.DONHANG_NAM d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM BTL1.CHITIETDH_BAC@BTL1_LINK_M01 c
        JOIN BTL1.DONHANG_BAC@BTL1_LINK_M01 d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM MAY3.CHITIETDH_TRUNG@BTL1_LINK_M03 c
        JOIN MAY3.DONHANG_TRUNG@BTL1_LINK_M03 d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH
    );

    RETURN v_TongSL;
END;
/
--5 test case máy 2:
-- TC1: Khách hàng có dữ liệu thực tế trên máy 2
SELECT FN_TONG_SOLUONG_SP_KH_M2('KH01844') AS TongSL FROM dual;

-- TC2: Khách hàng có thể có đơn trên nhiều miền
SELECT FN_TONG_SOLUONG_SP_KH_M2('KH00001') AS TongSL FROM dual;

-- TC3: Khách hàng có thể không phát sinh đơn
SELECT FN_TONG_SOLUONG_SP_KH_M2('KH05000') AS TongSL FROM dual;

-- TC4: Khách hàng không tồn tại
SELECT FN_TONG_SOLUONG_SP_KH_M2('KH99999') AS TongSL FROM dual;

-- TC5: Mã khách hàng NULL
SELECT FN_TONG_SOLUONG_SP_KH_M2(NULL) AS TongSL FROM dual;

-- ============================================================
-- MÁY 3
-- ============================================================
CREATE OR REPLACE FUNCTION FN_TONG_SOLUONG_SP_KH_M3 (
    p_MaKH IN VARCHAR2
)
RETURN NUMBER
AS
    v_TongSL NUMBER := 0;
BEGIN
    IF p_MaKH IS NULL THEN
        RETURN 0;
    END IF;

    SELECT NVL(SUM(SoLuong), 0)
    INTO v_TongSL
    FROM (
        SELECT c.SoLuong
        FROM CHITIETDH_TRUNG c
        JOIN DONHANG_TRUNG d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM BTL1.CHITIETDH_BAC@BTL1_LINK_M01 c
        JOIN BTL1.DONHANG_BAC@BTL1_LINK_M01 d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH

        UNION ALL

        SELECT c.SoLuong
        FROM MAY2_OWNER.CHITIETDH_NAM@BTL1_LINK_M02 c
        JOIN MAY2_OWNER.DONHANG_NAM@BTL1_LINK_M02 d ON c.MaDH = d.MaDH
        WHERE d.MaKH = p_MaKH
    );

    RETURN v_TongSL;
END;
/
-- ============================================================
--5 test case máy 3: 
-- TC1: Khách hàng có dữ liệu thực tế
SELECT FN_TONG_SOLUONG_SP_KH_M3('KH01844') AS TongSL FROM dual;

-- TC2: Khách hàng có thể có đơn trên nhiều miền
SELECT FN_TONG_SOLUONG_SP_KH_M3('KH00001') AS TongSL FROM dual;

-- TC3: Khách hàng có thể không phát sinh đơn
SELECT FN_TONG_SOLUONG_SP_KH_M3('KH05000') AS TongSL FROM dual;

-- TC4: Khách hàng không tồn tại
SELECT FN_TONG_SOLUONG_SP_KH_M3('KH99999') AS TongSL FROM dual;

-- TC5: Mã khách hàng NULL
SELECT FN_TONG_SOLUONG_SP_KH_M3(NULL) AS TongSL FROM dual;

-- ============================================================

-------------------------------PROCEDURE-------------------------
-- MÁY 1
-- ============================================================
CREATE OR REPLACE PROCEDURE TaoDonHang_M1 (
    p_MaDH     VARCHAR2,
    p_MaKH     VARCHAR2,
    p_MaSP     VARCHAR2,
    p_SoLuong  NUMBER,
    p_EmailMoi VARCHAR2
)
IS
    v_DonGia NUMBER;
    v_ThanhTien NUMBER;
    v_CheckKH NUMBER;
BEGIN
    IF LENGTH(p_MaDH) > 10 THEN
        RAISE_APPLICATION_ERROR(-20000, 'MaDH khong duoc qua 10 ky tu');
    END IF;

    IF p_SoLuong <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'So luong phai lon hon 0');
    END IF;

    SELECT COUNT(*) INTO v_CheckKH
    FROM KHACHHANG
    WHERE MaKH = p_MaKH;

    IF v_CheckKH = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Khach hang khong ton tai');
    END IF;

    BEGIN
        SELECT DonGia INTO v_DonGia
        FROM SANPHAM_INFO
        WHERE MaSP = p_MaSP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'San pham khong ton tai');
    END;

    v_ThanhTien := v_DonGia * p_SoLuong;

    INSERT INTO DONHANG_BAC(MaDH, MaKH, NgayDat, TrangThai, KhuVuc, TongTien)
    VALUES (p_MaDH, p_MaKH, SYSDATE, 'CHO_XU_LY', 'Bac', v_ThanhTien);

    INSERT INTO CHITIETDH_BAC(MaDH, MaSP, SoLuong, DonGia, ThanhTien)
    VALUES (p_MaDH, p_MaSP, p_SoLuong, v_DonGia, v_ThanhTien);

    UPDATE KHACHHANG
    SET Email = p_EmailMoi
    WHERE MaKH = p_MaKH;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
--5 TEST CASE MÁY 1
-- Dọn dữ liệu test cũ
DELETE FROM CHITIETDH_BAC WHERE MaDH IN ('DHTB01','DHTB02','DHTB03','DHTB04');
DELETE FROM DONHANG_BAC WHERE MaDH IN ('DHTB01','DHTB02','DHTB03','DHTB04');
COMMIT;

-- TC1: Hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP SANPHAM_INFO.MaSP%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Bac' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM SANPHAM_INFO WHERE ROWNUM = 1;

    TaoDonHang_M1('DHTB01', v_MaKH, v_MaSP, 2, 'bac_test1@gmail.com');
END;
/

-- TC2: Số lượng không hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP SANPHAM_INFO.MaSP%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Bac' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM SANPHAM_INFO WHERE ROWNUM = 1;

    TaoDonHang_M1('DHTB02', v_MaKH, v_MaSP, 0, 'bac_test2@gmail.com');
END;
/

-- TC3: Khách hàng không tồn tại
DECLARE
    v_MaSP SANPHAM_INFO.MaSP%TYPE;
BEGIN
    SELECT MaSP INTO v_MaSP FROM SANPHAM_INFO WHERE ROWNUM = 1;

    TaoDonHang_M1('DHTB03', 'KH99999', v_MaSP, 2, 'bac_test3@gmail.com');
END;
/

-- TC4: Sản phẩm không tồn tại
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Bac' AND ROWNUM = 1;

    TaoDonHang_M1('DHTB04', v_MaKH, 'SP99999', 2, 'bac_test4@gmail.com');
END;
/

-- TC5: Trùng mã đơn hàng
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP SANPHAM_INFO.MaSP%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Bac' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM SANPHAM_INFO WHERE ROWNUM = 1;

    TaoDonHang_M1('DHTB01', v_MaKH, v_MaSP, 1, 'bac_test5@gmail.com');
END;
/

-- ============================================================
-- MÁY 2
-- ============================================================
CREATE OR REPLACE PROCEDURE TaoDonHang_M2 (
    p_MaDH     VARCHAR2,
    p_MaKH     VARCHAR2,
    p_MaSP     VARCHAR2,
    p_SoLuong  NUMBER,
    p_EmailMoi VARCHAR2
)
IS
    v_DonGia NUMBER;
    v_ThanhTien NUMBER;
    v_CheckKH NUMBER;
BEGIN
    IF LENGTH(p_MaDH) > 10 THEN
        RAISE_APPLICATION_ERROR(-20000, 'MaDH khong duoc qua 10 ky tu');
    END IF;

    IF p_SoLuong <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'So luong phai lon hon 0');
    END IF;

    SELECT COUNT(*) INTO v_CheckKH
    FROM KHACHHANG
    WHERE MaKH = p_MaKH;

    IF v_CheckKH = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Khach hang khong ton tai');
    END IF;

    BEGIN
        SELECT DonGia INTO v_DonGia
        FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01
        WHERE MaSP = p_MaSP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'San pham khong ton tai');
    END;

    v_ThanhTien := v_DonGia * p_SoLuong;

    INSERT INTO DONHANG_NAM(MaDH, MaKH, NgayDat, TrangThai, KhuVuc, TongTien)
    VALUES (p_MaDH, p_MaKH, SYSDATE, 'CHO_XU_LY', 'Nam', v_ThanhTien);

    INSERT INTO CHITIETDH_NAM(MaDH, MaSP, SoLuong, DonGia, ThanhTien)
    VALUES (p_MaDH, p_MaSP, p_SoLuong, v_DonGia, v_ThanhTien);

    UPDATE KHACHHANG
    SET Email = p_EmailMoi
    WHERE MaKH = p_MaKH;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
-- 5 TEST CASE MÁY 2
-- Dọn dữ liệu test cũ
DELETE FROM CHITIETDH_NAM WHERE MaDH IN ('DHTN01','DHTN02','DHTN03','DHTN04');
DELETE FROM DONHANG_NAM WHERE MaDH IN ('DHTN01','DHTN02','DHTN03','DHTN04');
COMMIT;
-- TC1: Hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Nam' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M2('DHTN01', v_MaKH, v_MaSP, 2, 'nam_test1@gmail.com');
END;
/
-- TC2: Số lượng không hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Nam' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M2('DHTN02', v_MaKH, v_MaSP, 0, 'nam_test2@gmail.com');
END;
/
-- TC3: Khách hàng không tồn tại
DECLARE
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M2('DHTN03', 'KH99999', v_MaSP, 2, 'nam_test3@gmail.com');
END;
/
-- TC4: Sản phẩm không tồn tại
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Nam' AND ROWNUM = 1;

    TaoDonHang_M2('DHTN04', v_MaKH, 'SP99999', 2, 'nam_test4@gmail.com');
END;
/
-- TC5: Trùng mã đơn hàng
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Nam' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M2('DHTN01', v_MaKH, v_MaSP, 1, 'nam_test5@gmail.com');
END;
/

-- ============================================================
-- MÁY 3
-- ============================================================
CREATE OR REPLACE PROCEDURE TaoDonHang_M3 (
    p_MaDH     VARCHAR2,
    p_MaKH     VARCHAR2,
    p_MaSP     VARCHAR2,
    p_SoLuong  NUMBER,
    p_EmailMoi VARCHAR2
)
IS
    v_DonGia NUMBER;
    v_ThanhTien NUMBER;
    v_CheckKH NUMBER;
BEGIN
    IF LENGTH(p_MaDH) > 10 THEN
        RAISE_APPLICATION_ERROR(-20000, 'MaDH khong duoc qua 10 ky tu');
    END IF;

    IF p_SoLuong <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'So luong phai lon hon 0');
    END IF;

    SELECT COUNT(*) INTO v_CheckKH
    FROM KHACHHANG
    WHERE MaKH = p_MaKH;

    IF v_CheckKH = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Khach hang khong ton tai');
    END IF;

    BEGIN
        SELECT DonGia INTO v_DonGia
        FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01
        WHERE MaSP = p_MaSP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'San pham khong ton tai');
    END;

    v_ThanhTien := v_DonGia * p_SoLuong;

    INSERT INTO DONHANG_TRUNG(MaDH, MaKH, NgayDat, TrangThai, KhuVuc, TongTien)
    VALUES (p_MaDH, p_MaKH, SYSDATE, 'CHO_XU_LY', 'Trung', v_ThanhTien);

    INSERT INTO CHITIETDH_TRUNG(MaDH, MaSP, SoLuong, DonGia, ThanhTien)
    VALUES (p_MaDH, p_MaSP, p_SoLuong, v_DonGia, v_ThanhTien);

    UPDATE KHACHHANG
    SET Email = p_EmailMoi
    WHERE MaKH = p_MaKH;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
-- ============================================================
-- 5 TEST CASE MÁY 3
-- Dọn dữ liệu test cũ
DELETE FROM CHITIETDH_TRUNG WHERE MaDH IN ('DHTT01','DHTT02','DHTT03','DHTT04');
DELETE FROM DONHANG_TRUNG WHERE MaDH IN ('DHTT01','DHTT02','DHTT03','DHTT04');
COMMIT;

-- TC1: Hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Trung' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M3('DHTT01', v_MaKH, v_MaSP, 2, 'trung_test1@gmail.com');
END;
/

-- TC2: Số lượng không hợp lệ
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Trung' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M3('DHTT02', v_MaKH, v_MaSP, 0, 'trung_test2@gmail.com');
END;
/

-- TC3: Khách hàng không tồn tại
DECLARE
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M3('DHTT03', 'KH99999', v_MaSP, 2, 'trung_test3@gmail.com');
END;
/

-- TC4: Sản phẩm không tồn tại
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Trung' AND ROWNUM = 1;

    TaoDonHang_M3('DHTT04', v_MaKH, 'SP99999', 2, 'trung_test4@gmail.com');
END;
/

-- TC5: Trùng mã đơn hàng
DECLARE
    v_MaKH KHACHHANG.MaKH%TYPE;
    v_MaSP VARCHAR2(8);
BEGIN
    SELECT MaKH INTO v_MaKH FROM KHACHHANG WHERE KhuVuc = 'Trung' AND ROWNUM = 1;
    SELECT MaSP INTO v_MaSP FROM BTL1.SANPHAM_INFO@BTL1_LINK_M01 WHERE ROWNUM = 1;

    TaoDonHang_M3('DHTT01', v_MaKH, v_MaSP, 1, 'trung_test5@gmail.com');
END;
/

-- ============================================================

----------------------------------------TRIGGER----------------------------
-- MÁY 1
-- ============================================================
CREATE OR REPLACE TRIGGER TRG_CAPNHAT_TONGTIEN_BAC
AFTER INSERT OR UPDATE OR DELETE ON CHITIETDH_BAC
DECLARE
BEGIN
    UPDATE DONHANG_BAC d
    SET TongTien = (
        SELECT NVL(SUM(c.ThanhTien), 0)
        FROM CHITIETDH_BAC c
        WHERE c.MaDH = d.MaDH
    );
END;
/
-- 5 TEST CASE MÁY 1
-- TC1: Kiểm tra TongTien ban đầu
SELECT MaDH, TongTien
FROM DONHANG_BAC
WHERE MaDH = 'DH0000001';

-- TC2: INSERT thêm chi tiết đơn hàng
INSERT INTO CHITIETDH_BAC
VALUES ('DH0000001', 'SP99991', 2, 100000, 200000);

SELECT MaDH, TongTien
FROM DONHANG_BAC
WHERE MaDH = 'DH0000001';

-- TC3: UPDATE chi tiết đơn hàng
UPDATE CHITIETDH_BAC
SET SoLuong = 3,
    ThanhTien = 300000
WHERE MaDH = 'DH0000001'
  AND MaSP = 'SP99991';

SELECT MaDH, TongTien
FROM DONHANG_BAC
WHERE MaDH = 'DH0000001';

-- TC4: DELETE một chi tiết đơn hàng
DELETE FROM CHITIETDH_BAC
WHERE MaDH = 'DH0000001'
  AND MaSP = 'SP99991';

SELECT MaDH, TongTien
FROM DONHANG_BAC
WHERE MaDH = 'DH0000001';

-- TC5: Xóa toàn bộ chi tiết của đơn hàng test
DELETE FROM CHITIETDH_BAC
WHERE MaDH = 'DH0000001';

SELECT MaDH, TongTien
FROM DONHANG_BAC
WHERE MaDH = 'DH0000001';

ROLLBACK;
-- ============================================================
-- MÁY 2
-- ============================================================
CREATE OR REPLACE TRIGGER TRG_CAPNHAT_TONGTIEN_NAM
AFTER INSERT OR UPDATE OR DELETE ON CHITIETDH_NAM
DECLARE
BEGIN
    UPDATE DONHANG_NAM d
    SET TongTien = (
        SELECT NVL(SUM(c.ThanhTien), 0)
        FROM CHITIETDH_NAM c
        WHERE c.MaDH = d.MaDH
    );
END;
/
-- 5 TEST CASE MÁY 2
-- TC1: Kiểm tra TongTien ban đầu
SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';

-- TC2: INSERT thêm chi tiết đơn hàng
INSERT INTO CHITIETDH_NAM
VALUES ('DH0000166', 'SP99991', 2, 100000, 200000);

SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';

-- TC3: UPDATE chi tiết vừa thêm
UPDATE CHITIETDH_NAM
SET SoLuong = 5,
    ThanhTien = 500000
WHERE MaDH = 'DH0000166'
  AND MaSP = 'SP99991';

SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';

-- TC4: DELETE chi tiết vừa thêm
DELETE FROM CHITIETDH_NAM
WHERE MaDH = 'DH0000166'
  AND MaSP = 'SP99991';

SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';

-- TC5: INSERT rồi ROLLBACK để kiểm tra không làm bẩn dữ liệu
INSERT INTO CHITIETDH_NAM
VALUES ('DH0000166', 'SP99992', 1, 300000, 300000);

SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';

ROLLBACK;

SELECT MaDH, TongTien
FROM DONHANG_NAM
WHERE MaDH = 'DH0000166';
-- ============================================================
-- MÁY 3
-- ============================================================
CREATE OR REPLACE TRIGGER TRG_CAPNHAT_TONGTIEN_TRUNG
AFTER INSERT OR UPDATE OR DELETE ON CHITIETDH_TRUNG
DECLARE
BEGIN
    UPDATE DONHANG_TRUNG d
    SET TongTien = (
        SELECT NVL(SUM(c.ThanhTien), 0)
        FROM CHITIETDH_TRUNG c
        WHERE c.MaDH = d.MaDH
    );
END;
/
-- 5 TEST CASE MÁY 3
-- TC1: Kiểm tra TongTien ban đầu
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';

-- TC2: INSERT thêm chi tiết đơn hàng
INSERT INTO CHITIETDH_TRUNG
VALUES ('DH0000005', 'SP99991', 2, 100000, 200000);
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';

-- TC3: UPDATE chi tiết đơn hàng
UPDATE CHITIETDH_TRUNG
SET SoLuong = 4,
    ThanhTien = 400000
WHERE MaDH = 'DH0000005'
  AND MaSP = 'SP99991';
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';

-- TC4: DELETE chi tiết vừa thêm
DELETE FROM CHITIETDH_TRUNG
WHERE MaDH = 'DH0000005'
  AND MaSP = 'SP99991';
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';

-- TC5: INSERT rồi ROLLBACK để bảo toàn dữ liệu
INSERT INTO CHITIETDH_TRUNG
VALUES ('DH0000005', 'SP99992', 1, 250000, 250000);
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';
ROLLBACK;
SELECT MaDH, TongTien
FROM DONHANG_TRUNG
WHERE MaDH = 'DH0000005';
-- ============================================================
