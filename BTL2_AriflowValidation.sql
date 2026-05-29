# Truy vấn index đơn hàng thông qua docker compose
docker compose exec redis-target redis-cli SMEMBERS may3:khachhang:KH02868:donhang 

# Truy vấn danh sách chi tiết đơn hàng thông qua docker compose
docker compose exec redis-target redis-cli LRANGE may3:donhang:DH0000018:chitiet 0 -1 

# Lấy kết quả validation sau quá trình migration
docker compose exec redis-target redis-cli GET migration:summary:latest 

# Kiểm tra tổng số phần tử (count) của danh sách đơn hàng từng site
docker compose exec redis-target redis-cli SCARD may1:donhang:index
docker compose exec redis-target redis-cli SCARD may2:donhang:index
docker compose exec redis-target redis-cli SCARD may3:donhang:index 

# Kiểm tra tổng số phần tử (count) của chi tiết đơn hàng từng site
docker compose exec redis-target redis-cli SCARD may1:chitietdh:index 
docker compose exec redis-target redis-cli SCARD may2:chitietdh:index 
docker compose exec redis-target redis-cli SCARD may3:chitietdh:index 