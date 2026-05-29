# Kiểm tra trạng thái Replication
INFO replication 

# Đọc mẫu 1 record
HGETALL khachhang:KH00014 

# Thêm nhiều khách hàng cùng lúc bằng MULTI
MULTI 
HSET khachhang:KH_BATCH_01 MAKH "KH_BATCH_01" HOTEN "Nguyen Van Batch 01" SODIENTHOAI "0900000001" EMAIL "batch01@gmail.com" THANHPHO "Can Tho" KHUVUC "Nam"
HSET khachhang:KH_BATCH_02 MAKH "KH_BATCH_02" HOTEN "Tran Thi Batch 02" SODIENTHOAI "0900000002" EMAIL "batch02@gmail.com" THANHPHO "Da Nang" KHUVUC "Trung"  
HSET khachhang:KH_BATCH_03 MAKH "KH_BATCH_03" HOTEN "Le Van Batch 03" SODIENTHOAI "0900000003" EMAIL "batch03@gmail.com" THANHPHO "Ha Noi" KHUVUC "Bac" 
HSET khachhang:KH_BATCH_04 MAKH "KH_BATCH_04" HOTEN "Pham Thi Batch 04" SODIENTHOAI "0900000004" EMAIL "batch04@gmail.com" THANHPHO "TP HCM" KHUVUC "Nam"  
HSET khachhang:KH_BATCH_05 MAKH "KH_BATCH_05" HOTEN "Hoang Van Batch 05" SODIENTHOAI "0900000005" EMAIL "batch05@gmail.com" THANHPHO "Hue" KHUVUC "Trung" 
EXEC

# Kiểm tra dữ liệu batch
SCAN 0 MATCH khachhang:KH_BATCH_* COUNT 20  
HMGET khachhang:KH_BATCH_01 MAKH HOTEN THANHPHO KHUVUC  
HMGET khachhang:KH_BATCH_02 MAKH HOTEN THANHPHO KHUVUC  
HMGET khachhang:KH_BATCH_03 MAKH HOTEN THANHPHO KHUVUC  
HMGET khachhang:KH_BATCH_04 MAKH HOTEN THANHPHO KHUVUC  
HMGET khachhang:KH_BATCH_05 MAKH HOTEN THANHPHO KHUVUC  

# Cập nhật nhiều khách hàng cùng lúc
MULTI  
HSET khachhang:KH_BATCH_01 THANHPHO "Ho Chi Minh" KHUVUC "Nam"  
HSET khachhang:KH_BATCH_02 THANHPHO "Quang Nam" KHUVUC "Trung"  
HSET khachhang:KH_BATCH_03 THANHPHO "Hai Phong" KHUVUC "Bac" 
HSET khachhang:KH_BATCH_04 THANHPHO "Binh Duong" KHUVUC "Nam" 
HSET khachhang:KH_BATCH_05 THANHPHO "Quang Tri" KHUVUC "Trung"  
EXEC 

# Đọc kiểm tra cập nhật batch trên Replica
HMGET khachhang:KH_BATCH_01 HOTEN THANHPHO KHUVUC # 
HMGET khachhang:KH_BATCH_02 HOTEN THANHPHO KHUVUC # 
HMGET khachhang:KH_BATCH_03 HOTEN THANHPHO KHUVUC # 
HMGET khachhang:KH_BATCH_04 HOTEN THANHPHO KHUVUC # 
HMGET khachhang:KH_BATCH_05 HOTEN THANHPHO KHUVUC # 

# Xóa nhiều khách hàng
DEL khachhang:KH_BATCH_01 khachhang:KH_BATCH_02 khachhang:KH_BATCH_03 khachhang:KH_BATCH_04 khachhang:KH_BATCH_05 # 

# Kiểm tra xóa
EXISTS khachhang:KH_BATCH_01 # 
EXISTS khachhang:KH_BATCH_02 # 
EXISTS khachhang:KH_BATCH_03 # 
EXISTS khachhang:KH_BATCH_04 # 
EXISTS khachhang:KH_BATCH_05 # 

# Test ghi trên Replica (sẽ báo lỗi Readonly)
HSET khachhang:KH_REPLICA_WRITE MAKH "KH_REPLICA_WRITE" HOTEN "Thu ghi tren replica" # 