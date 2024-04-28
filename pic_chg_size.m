% 该程序用于缩小图片尺寸，减少图片所占空间。
% 哪些图片置不要压缩？（精美的风景照、远景照）

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 用户配置?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Img_path = 'test\';
thre_mem = 300;  % threshold of memory of a picture, usually 400 KB
thre_size = 1200-1;    % if both long and width are <= this, skip (usually 0, 1500)

% size of the target image should meet:
% if long>=long_set and width>=width_set: make sure that (long_targ>=long_set and width_targ==width_set) or (long_targ==long_set and width_targ>=width_set)
% if long<=long_set or width<=width_set: don't change size
img_long_set = 1920;        % 默认压缩后的长边尺?（照片1920、2560）
img_long_set_1 = 3200;      % 在文?刑?(med)'字符串，压缩后的长边尺寸??
                        % 在文?刑?(big)'字符串，跳?猛计谎顾?
img_width_set = 1080;    % size of "width_targ" (default). if only want to use this parameter, set a very small "img_long_set"
flag_enlarge = 1;      % 1, enlage the size, but still skip the images that smaller than "thre_size"

chg2jpg = 1;   % 是否将非jpg图片变为jpg。  1，是
SubPathes = 1;   % 是否将目录下所有子目录下的图片都做处历剑  0，仅当前目录；1，?ㄋ凶幽柯?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rt = datetime;
pathes = genpath(Img_path);    % 获取该路径下所有子路径，得到一长串字符串
pathes_Initial = strfind(pathes,Img_path);   % 获取字符串中所有路径的首字母位置
clear pathes_list;
pathes_list(length(pathes_Initial),1) = struct('path',[]);   % 创建一个结构体装字符串，作为路径列?
for pl_i=1:length(pathes_Initial)                    % 路径列柄棼?
    if(pl_i<length(pathes_Initial))
        pathes_list(pl_i).path = pathes( pathes_Initial(pl_i) : pathes_Initial(pl_i+1)-2 );
    else
        pathes_list(pl_i).path = pathes( pathes_Initial(pl_i) : length(pathes)-1 );
    end
    if(pathes_list(pl_i).path(length(pathes_list(pl_i).path)) ~= '\') % 如果煮一个字符不是'\'，铁赜
        pathes_list(pl_i).path = [pathes_list(pl_i).path,'\'];
    end
end
backup_prefix = ['pb', num2str(rem(rt.Year,100)*10000+rt.Month*100+rt.Day,'%06d'), num2str(rt.Hour*100+rt.Minute,'%04d'), '_', ...
    strrep(strrep(pathes_list(1).path,'\','_'),':','')];  % the prefix of backup path
path1_len = size(pathes_list(1).path);
path1_len = path1_len(2);

Bar = waitbar(0,'changing size ...');

if(SubPathes~=0) % 选择是否将目录下所有子目录下的图片都做处?
    pathes_num = length(pathes_Initial);
else
    pathes_num = 1;
end

for j=1:pathes_num            % path select
    Img_path = pathes_list(j).path;
    disp(Img_path);               % 打印路径?

    Img_dir = dir([Img_path,'*.jpg']);  % 查找当前路径下所有图片
    Img_dir = [Img_dir; dir([Img_path,'*.png'])];
    Img_dir = [Img_dir; dir([Img_path,'*.bmp'])];
    Img_dir = [Img_dir; dir([Img_path,'*.jpeg'])];
    Img_dir = [Img_dir; dir([Img_path,'*.tga'])];
    Img_dir_len = length(Img_dir);
    
    path_len = size(Img_path);
    path_len = path_len(2);
    if (path_len>path1_len)
        backup_path_sub = Img_path( path1_len+1 : path_len );
    else
        backup_path_sub = '';
    end
    backup_path = [ 'pic_backup\', backup_prefix, '\', backup_path_sub ];
%     backup_path = [ 'pic_backup\', backup_prefix, strrep(strrep(Img_path,'\','_'),':','') ]; % 设定备份路径
%     backup_path = [Img_path, 'pic_backup\'];
    if length(backup_path) > 170    % 路径太长时的措施
        backup_path = backup_path(1:170);
        disp('    备份路径太长，截短');
        disp(['    backup_path = ',backup_path]);
    end
    mkdir(backup_path);

    num=0;
    if(Img_dir_len>0)    % judge if there are images in this path
        for i=1:Img_dir_len  % iterate over images
            waitbar(i/Img_dir_len)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%% 哪些图片跳??
            if(Img_dir(i).bytes<=thre_mem*1024)  %如果图片小于 thre_mem KB
                continue;
            end
            if(~isempty(strfind(Img_dir(i).name,'(big)'))) %如果含有
                continue; %跳?
            end
            Img = imread([Img_path, Img_dir(i).name]); % read image            
            Img_size = size(Img);               % get size of image
            if (Img_size(1)<=thre_size && Img_size(2)<=thre_size)  % if size is too small, skip
                continue;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% 哪些图片跳??
            
            % 确定缩放比例
            target_size_long = img_long_set;  %长边长度缩小为1600
            if(~isempty(strfind(Img_dir(i).name,'(med)'))) %如果含有
                target_size_long = img_long_set_1;  %长边长度缩小为2400
            end
            target_size_width = img_width_set;
            if(Img_size(1)>=Img_size(2))
                img_long = Img_size(1);
                img_width = Img_size(2);
            else
                img_long = Img_size(2);
                img_width = Img_size(1);
            end
            k_long = target_size_long/img_long;
            k_width = target_size_width/img_width;
            if (flag_enlarge == 0)
                k_long = min(1, k_long);  % can only reduce scale, can not enlarge it
                k_width = min(1, k_width);
            end
            k = max(k_long, k_width);
            
            % 图片缩放
            Img_Output = imresize(Img,k*[Img_size(1) Img_size(2)]);       % 长边尺寸变为1600
            movefile([Img_path, Img_dir(i).name], backup_path);  % pictures backup
            
            if(chg2jpg)                                 % change name
    %             delete([Img_path, Img_dir(i).name]);
                len = length(Img_dir(i).name);
                if( Img_dir(i).name(len-4:len)=='.jpeg' )
                    Img_dir(i).name = [Img_dir(i).name(1:len-4), 'jpg'];
                else
                    Img_dir(i).name(len-2:len)='jpg';
                end
            end
            
            if isa(Img_Output, 'uint16')  % strcmp(class(Img_Output),'uint16')
                % 可能由于颜色位数较深
                % 会报这个error：“UINT16 image data requires bitdepth specifically set to either 12 or 16.”，因此添加该判断 
%                 imwrite(Img_Output,[Img_path, Img_dir(i).name], 'BitDepth', 8);  % save the new image
                Img_Output = uint8((Img_Output + 128) / 256);
                % MATLAB处理后，颜色可能发生改变，用win画图软件压缩则不会。
            end
            imwrite(Img_Output,[Img_path, Img_dir(i).name]);  % save the new image
    %         pause(0.4);
            num=num+1;

        end
        disp(['    OK    ',num2str(num),' pictures changed']);
    else
        disp('END    no picture in this path');
    end

end % path select
close(Bar);





%% 特殊操作，将一张指定图片压缩。
if(0)
    Img_path = 'F:\JYZ_Memory\03 大学\2018-03~2018-08 大四2\！1生畸x';
    Img_name = '2018-03-02 081718 生日??jpg';
    Size_of_LongerSide = 1600;  %长边长度缩小为1600

    Img = imread([Img_path, Img_name]);%读图
    Img_size = size(Img);  %获得尺?
    if(Img_size(1)>=Img_size(2))
        k = min( 1 , Size_of_LongerSide/Img_size(1) );
    else
        k = min( 1 , Size_of_LongerSide/Img_size(2) );
    end
    if(k<=1)
        Img_Output = imresize(Img,k*[Img_size(1) Img_size(2)]); %长边尺寸变为1600
        imwrite(Img_Output,[Img_path, Img_name]);  %保存图片
    end

    disp('OK');
end
