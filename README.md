# MATLAB图片批量压缩脚本

## 功能

将某路径下的所有图片压缩，适用于整理照片、缩小图片占用空间的场景。

## 使用方法

### 1 打开MATLAB，配置pic_chg_size.m中的参数

- Img_path：路径
- thre_mem：图片占用空间大小阈值(MB)，小于等于该值的图片不会被压缩。
- thre_size：图片长宽阈值(像素)，若图片长宽都小于等于该值，图片不会被压缩。
- img_long_set：设置压缩后图片长边的像素值。
- img_long_set_1：设置第二级压缩后图片长边的像素值。要大于img_long_set。
- img_width_set：设置压缩后图片短边的最小像素值。防止压缩类似长图、全景图时，其短边值过小。
- flag_enlarge：长宽值压缩后是否允许增大。1表示允许，0表示不允许。如果设为1，则当图片长宽小于img_long_set、img_width_set，但有一个大于thre_size时，图片就会被做压缩处理，压缩后长宽像素值会变大。
- chg2jpg：是否将一些非jpg图片转换为jpg，1表示是
- SubPathes：处理范围是否包括路径下的所有子路径。1表示是，0表示否。设为0时，仅处理Img_path路径下的文件。

### 2 检查路径下的图片

当图片满足参数中设置的压缩要求时，图片会被压缩，压缩后的 “长, 短” 边像素值默认大于等于 “img_long_set, img_width_set”；若在图片文件名中添加字符串**"(med)"**，则压缩后的 “长, 短” 边像素值大于等于 “img_long_set_1, img_width_set”；若在图片文件名中添加字符串**"(big)"**，则图片不会被压缩。

### 3 运行程序，等待完成

被压缩处理的图片会覆盖原图片，原图片会被移动到pic_backup路径下备份。