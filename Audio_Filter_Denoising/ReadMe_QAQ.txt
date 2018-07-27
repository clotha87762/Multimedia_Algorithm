-------------Assignment 3 ReadMe--------------

想要聽第一題的結果，請聽audio1，audio2，audio3，三首分別是低中高頻率的三首歌
(小蜜蜂、瑪莉小綿羊、兩隻老虎)

(因為我抓出來最適當的filter是使用rectangular windowing，
 而且助教有跟我說windowing function可以用Recangular，
 只要額外有把其他windowing function的code也寫上去就好了，所以我就用rectangular了)

code的部分我把第一題跟第二題全部都寫在hw3.m裡面了，
不過兩題也都會用到我修改過的myFilter.m檔 (convolution也弄在裡面)

第二題的結果，dithered是noise dithering之後的音樂、
shaped是dithering跟noise shaping之後的音樂、
filtered是最後又做過low-pass filtering的最後結果。
test是供比較用的音訊檔，為沒有經過dithering&noise shaping直接做low-pass filtering
的結果。

跑code的時候會噴出很多figure，不過上面我都打上標題了。

