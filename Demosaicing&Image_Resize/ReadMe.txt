
注意~~~看Dithering出來的圖片時最好調整到適當比例 ，QQ 因為電腦內建Upsampling對黑白圖的
效果實在不太好  



共有四個 .m檔:
Demosaicing.m
Dithering.m
Interpolation.m
LenaDithering.m

Report檔 : Introduction to Multimedia HW1 Report.pdf

執行Demosaicing觀看第一題的結果
結果會存成temp.jpg
absolute color difference會存在Diff.jpg裡面
PSNR則會直接fprintf在matlab commandline裏頭

執行Dithering.m觀看第二題結果 (會讀取DitheringImage.jpg) <---自選圖  
結果會有:
random.jpg (對每個像素隨機取值 0~255做Threshold)
averageDithering.jpg (取圖片明暗平均值以此做Threshold)
pattern.jpg (用跟講義上相同的3*3Thresholding_Matrix做Pattern Dithering)
errorDiffusion1.jpg (用pdf上2*3的mask去做Dithering)

Dithering會跑久一點><

執行LenaDithering觀看第二題對Lena圖的運算結果
方法同上，只是產生的檔名前面會多了'Lena' ， i.e. ' Lenarandom.jpg'

執行Interpolation觀看第三題結果
結果輸出成 'NearestNeighbor.jpg' 和 ' BiLinear.jpg'





