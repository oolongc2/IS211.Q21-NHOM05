SELECT index_name, table_name, index_type
FROM user_indexes
WHERE index_name LIKE 'IDX_M%'
ORDER BY table_name, index_name;
---------------------------
BEGIN
    FOR i IN (
        SELECT index_name
        FROM user_indexes
        WHERE index_name LIKE 'IDX_%'
    ) LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || i.index_name;
    END LOOP;
END;
/
-----======================QUERY 1: TONG TIEN=============================----------------
ALTER SYSTEM FLUSH SHARED_POOL;
---------------------------
CREATE INDEX IDX_M2_DH_MAKH_TONGTIEN
ON DONHANG_NAM (MaKH, TongTien);
COMMIT;
----------------------------
ALTER SYSTEM FLUSH SHARED_POOL;

EXPLAIN PLAN FOR
SELECT 
    q.Mien,
    q.MaDH,
    q.MaKH,
    q.HoTen,
    q.TongTien,
    FN_XEPLOAI_KH_M2(q.TongTien) AS XepLoai,
    SUM(q.SoLuong) AS TongSoLuong,
    SUM(q.ThanhTien) AS TongChiTiet
FROM (
    SELECT 
        'NAM' AS Mien,
        d.MaDH,
        d.MaKH,
        k.HoTen,
        d.TongTien,
        c.SoLuong,
        c.ThanhTien
    FROM DONHANG_NAM d
    JOIN KHACHHANG k
        ON d.MaKH = k.MaKH
    JOIN CHITIETDH_NAM c
        ON d.MaDH = c.MaDH
    WHERE d.MaKH = 'KH01844'
      AND d.TongTien > (
            SELECT AVG(TongTien)
            FROM DONHANG_NAM
        )

    UNION ALL

    SELECT 
        'BAC' AS Mien,
        d.MaDH,
        d.MaKH,
        k.HoTen,
        d.TongTien,
        c.SoLuong,
        c.ThanhTien
    FROM BTL1.DONHANG_BAC@BTL1_LINK_M01 d
    JOIN BTL1.KHACHHANG@BTL1_LINK_M01 k
        ON d.MaKH = k.MaKH
    JOIN BTL1.CHITIETDH_BAC@BTL1_LINK_M01 c
        ON d.MaDH = c.MaDH
    WHERE d.MaKH = 'KH01844'
      AND d.TongTien > (
            SELECT AVG(TongTien)
            FROM BTL1.DONHANG_BAC@BTL1_LINK_M01
        )

    UNION ALL

    SELECT 
        'TRUNG' AS Mien,
        d.MaDH,
        d.MaKH,
        k.HoTen,
        d.TongTien,
        c.SoLuong,
        c.ThanhTien
    FROM MAY3.DONHANG_TRUNG@BTL1_LINK_M03 d
    JOIN MAY3.KHACHHANG@BTL1_LINK_M03 k
        ON d.MaKH = k.MaKH
    JOIN MAY3.CHITIETDH_TRUNG@BTL1_LINK_M03 c
        ON d.MaDH = c.MaDH
    WHERE d.MaKH = 'KH01844'
      AND d.TongTien > (
            SELECT AVG(TongTien)
            FROM MAY3.DONHANG_TRUNG@BTL1_LINK_M03
        )
) q
GROUP BY 
    q.Mien,
    q.MaDH,
    q.MaKH,
    q.HoTen,
    q.TongTien
HAVING SUM(q.SoLuong) >= 3
/

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--------------============QUERY 2: TRANG THAI=================--------------------------
ALTER SYSTEM FLUSH SHARED_POOL;
----------------------------------
DROP INDEX IDX_M2_DH_TRANGTHAI;
COMMIT;
--------------------------------
CREATE BITMAP INDEX IDX_M2_DH_TRANGTHAI
ON DONHANG_NAM (TrangThai);
COMMIT;
----------------------------------
ALTER SYSTEM FLUSH SHARED_POOL;

EXPLAIN PLAN FOR
SELECT 
    TrangThai,
    COUNT(*) AS SoDonHang,
    SUM(CASE WHEN Mien = 'NAM' THEN 1 ELSE 0 END) AS SoDonNam,
    SUM(CASE WHEN Mien = 'BAC' THEN 1 ELSE 0 END) AS SoDonBac,
    SUM(CASE WHEN Mien = 'TRUNG' THEN 1 ELSE 0 END) AS SoDonTrung,
    SUM(TongTien) AS TongDoanhThu
FROM (
    SELECT 'NAM' AS Mien, TrangThai, KhuVuc, TongTien
    FROM DONHANG_NAM
    WHERE TrangThai IN ('DaGiao', 'DangXuLy')
      AND KhuVuc = 'Nam'

    UNION ALL

    SELECT 'BAC' AS Mien, TrangThai, KhuVuc, TongTien
    FROM BTL1.DONHANG_BAC@BTL1_LINK_M01
    WHERE TrangThai IN ('DaGiao', 'DangXuLy')
      AND KhuVuc = 'Bac'

    UNION ALL

    SELECT 'TRUNG' AS Mien, TrangThai, KhuVuc, TongTien
    FROM MAY3.DONHANG_TRUNG@BTL1_LINK_M03
    WHERE TrangThai IN ('DaGiao', 'DangXuLy')
      AND KhuVuc = 'Trung'
)
GROUP BY TrangThai
HAVING COUNT(*) > 0
/

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);



