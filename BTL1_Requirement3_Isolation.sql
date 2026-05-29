-- =========================================================================
-- CHƯƠNG 3: CÁC MỨC CÔ LẬP (ISOLATION LEVEL) TRONG MÔI TRƯỜNG PHÂN TÁN
-- =========================================================================

-- -------------------------------------------------------------------------
-- 3.1 LOST UPDATE
-- -------------------------------------------------------------------------

-- [3.1.1] Mức READ COMMITTED
-- Transaction 1 (Máy 1)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SELECT SoLuong, DonGia, ThanhTien FROM CHITIETDH_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006' AND MASP = 'SP0016'; 
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH02292') AS TongSL_Truoc FROM dual; 

-- Transaction 2 (Máy 3)
UPDATE CHITIETDH_TRUNG SET SoLuong = SoLuong + 3, ThanhTien = ThanhTien + 700000 WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
COMMIT; 

-- Transaction 1 (Máy 1) tiếp tục
UPDATE CHITIETDH_TRUNG@BTL1_LINK_M03 SET SoLuong = 17, ThanhTien = 17 * DonGia WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
COMMIT; 
SELECT SoLuong, DonGia, ThanhTien FROM CHITIETDH_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH02292') AS TongSL_Sau FROM dual; 


-- [3.1.2] Mức SERIALIZABLE
-- Transaction 1 (Máy 1)
COMMIT; 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
SELECT SoLuong, DonGia, ThanhTien FROM CHITIETDH_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 

-- Transaction 2 (Máy 3)
UPDATE CHITIETDH_TRUNG SET SoLuong = SoLuong + 3, ThanhTien = ThanhTien + 700000 WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
COMMIT; 

-- Transaction 1 (Máy 1) tiếp tục
UPDATE CHITIETDH_TRUNG@BTL1_LINK_M03 SET SoLuong = 19, ThanhTien = 19 * DonGia WHERE MaDH = 'DH0000006' AND MaSP = 'SP0016'; 
ROLLBACK; 


-- -------------------------------------------------------------------------
-- 3.2 NON-REPEATABLE READ
-- -------------------------------------------------------------------------

-- [3.2.1] Mức READ COMMITTED
-- Transaction 1 (Máy 1)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH02292') AS TongSL_Lan1 FROM dual; 

-- Transaction 2 (Máy 3)
UPDATE CHITIETDH_TRUNG SET SoLuong = SoLuong + 3, ThanhTien = ThanhTien + 700000 WHERE MaDH = 'DH0000006'; 
COMMIT;

-- Transaction 1 (Máy 1) tiếp tục
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH02292') AS TongSL_Lan2 FROM dual; 
UPDATE CHITIETDH_TRUNG@BTL1_LINK_M03 SET ThanhTien = ThanhTien + 100000 WHERE MaDH = 'DH0000006'; 
COMMIT; 


-- [3.2.2] Mức SERIALIZABLE
-- Transaction 1 (Máy 1)
COMMIT; 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH000001') AS TongSL_Lan1 FROM dual; 

-- Transaction 2 (Máy 3)
UPDATE CHITIETDH_TRUNG SET SoLuong = SoLuong + 4, ThanhTien = ThanhTien + 900000 WHERE MaDH = 'DH0000006'; 
COMMIT; 

-- Transaction 1 (Máy 1) tiếp tục
SELECT TongTien FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006'; 
SELECT FN_TONG_SOLUONG_SP_KH_M3@BTL1_LINK_M03('KH000001') AS TongSL_Lan2 FROM dual; 
UPDATE DONHANG_TRUNG@BTL1_LINK_M03 SET TrangThai = 'Da giao' WHERE MaDH = 'DH0000006'; 
ROLLBACK; 


-- -------------------------------------------------------------------------
-- 3.3 PHANTOM READ
-- -------------------------------------------------------------------------

-- [3.3.1] Mức READ COMMITTED
-- Transaction 1 (Máy 1)
COMMIT; 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SELECT FN_DEM_DON_THEO_TRANGTHAI_M3@BTL1_LINK_M03('Da giao') AS SoDon_Lan1 FROM dual; 

-- Transaction 2 (Máy 3)
INSERT INTO DONHANG_TRUNG (MaDH, MaKH, KhuVuc, TrangThai, TongTien) VALUES ('DH9999913', 'KH000001', 'Trung', 'Da giao', 0); 
INSERT INTO CHITIETDH_TRUNG (MaDH, MaSP, SoLuong, DonGia, ThanhTien) VALUES ('DH9999913', 'SP000001', 2, 250000, 500000); 
COMMIT; 

-- Transaction 1 (Máy 1) tiếp tục
SELECT FN_DEM_DON_THEO_TRANGTHAI_M3@BTL1_LINK_M03('Da giao') AS SoDon_Lan2 FROM dual; 
UPDATE DONHANG_TRUNG@BTL1_LINK_M03 SET TrangThai = 'Dang xu ly' WHERE MaDH = 'DH9999918'; 
COMMIT; 


-- [3.3.2] Mức SERIALIZABLE
-- Transaction 1 (Máy 1)
COMMIT; 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
SELECT FN_DEM_DON_THEO_TRANGTHAI_M3@BTL1_LINK_M03('Da giao') AS SoDon_Lan1 FROM dual; 

-- Transaction 2 (Máy 3)
INSERT INTO DONHANG_TRUNG (MaDH, MaKH, KhuVuc, TrangThai, TongTien) VALUES ('DH9999919', 'KH000001', 'Trung', 'Da giao', 0); 
INSERT INTO CHITIETDH_TRUNG (MaDH, MaSP, SoLuong, DonGia, ThanhTien) VALUES ('DH9999919', 'SP000001', 1, 300000, 300000); 
COMMIT; 

-- Transaction 1 (Máy 1) tiếp tục
SELECT FN_DEM_DON_THEO_TRANGTHAI_M3@BTL1_LINK_M03('Da giao') AS SoDon_Lan2 FROM dual; 
UPDATE DONHANG_TRUNG@BTL1_LINK_M03 SET TrangThai = 'Dang xu ly' WHERE MaDH = 'DH9999919'; 
COMMIT; 


-- -------------------------------------------------------------------------
-- 3.4 DEADLOCK
-- -------------------------------------------------------------------------

-- Mức READ COMMITTED
-- Transaction 1 (Máy 1)
COMMIT; 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SELECT * FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000006' FOR UPDATE; 

-- Transaction 3 (Máy 3)
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SELECT * FROM DONHANG_TRUNG WHERE MaDH = 'DH0000858' FOR UPDATE; 

-- Transaction 1 (Máy 1) tiếp tục
SELECT * FROM DONHANG_TRUNG@BTL1_LINK_M03 WHERE MaDH = 'DH0000858' FOR UPDATE;

-- Transaction 3 (Máy 3) tiếp tục
SELECT * FROM DONHANG_TRUNG WHERE MaDH = 'DH0000006' FOR UPDATE; 

-- (Lúc này Oracle phát hiện deadlock và báo lỗi ORA-00060)

-- Transaction 1 (Máy 1)
ROLLBACK; 

-- Transaction 3 (Máy 3)
ROLLBACK;