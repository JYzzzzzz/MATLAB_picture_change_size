% �ó���������СͼƬ�ߴ磬����ͼƬ��ռ�ռ䡣
% ��ЩͼƬ���ò�Ҫѹ�����������ķ羰�ա�Զ���գ�

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �û�����?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Img_path = 'test\';
thre_mem = 300;  % threshold of memory of a picture, usually 400 KB
thre_size = 1200-1;    % if both long and width are <= this, skip (usually 0, 1500)

% size of the target image should meet:
% if long>=long_set and width>=width_set: make sure that (long_targ>=long_set and width_targ==width_set) or (long_targ==long_set and width_targ>=width_set)
% if long<=long_set or width<=width_set: don't change size
img_long_set = 1920;        % Ĭ��ѹ����ĳ��߳�?����Ƭ1920��2560��
img_long_set_1 = 3200;      % ����?������?(med)'�ַ�����ѹ����ĳ��߳ߴ�??
                        % ����?������?(big)'�ַ�������?�ͼƬ����ѹ�?
img_width_set = 1080;    % size of "width_targ" (default). if only want to use this parameter, set a very small "img_long_set"
flag_enlarge = 1;      % 1, enlage the size, but still skip the images that smaller than "thre_size"

chg2jpg = 1;   % �Ƿ񽫷�jpgͼƬ��Ϊjpg��  1����
SubPathes = 1;   % �Ƿ�Ŀ¼��������Ŀ¼�µ�ͼƬ����������  0������ǰĿ¼��1��?�������Ŀ�?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rt = datetime;
pathes = genpath(Img_path);    % ��ȡ��·����������·�����õ�һ�����ַ���
pathes_Initial = strfind(pathes,Img_path);   % ��ȡ�ַ���������·��������ĸλ��
clear pathes_list;
pathes_list(length(pathes_Initial),1) = struct('path',[]);   % ����һ���ṹ��װ�ַ�������Ϊ·����?
for pl_i=1:length(pathes_Initial)                    % ·���б���?
    if(pl_i<length(pathes_Initial))
        pathes_list(pl_i).path = pathes( pathes_Initial(pl_i) : pathes_Initial(pl_i+1)-2 );
    else
        pathes_list(pl_i).path = pathes( pathes_Initial(pl_i) : length(pathes)-1 );
    end
    if(pathes_list(pl_i).path(length(pathes_list(pl_i).path)) ~= '\') % �������һ���ַ�����'\'������
        pathes_list(pl_i).path = [pathes_list(pl_i).path,'\'];
    end
end
backup_prefix = ['pb', num2str(rem(rt.Year,100)*10000+rt.Month*100+rt.Day,'%06d'), num2str(rt.Hour*100+rt.Minute,'%04d'), '_', ...
    strrep(strrep(pathes_list(1).path,'\','_'),':','')];  % the prefix of backup path
path1_len = size(pathes_list(1).path);
path1_len = path1_len(2);

Bar = waitbar(0,'changing size ...');

if(SubPathes~=0) % ѡ���Ƿ�Ŀ¼��������Ŀ¼�µ�ͼƬ������?
    pathes_num = length(pathes_Initial);
else
    pathes_num = 1;
end

for j=1:pathes_num            % path select
    Img_path = pathes_list(j).path;
    disp(Img_path);               % ��ӡ·��?

    Img_dir = dir([Img_path,'*.jpg']);  % ���ҵ�ǰ·��������ͼƬ
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
%     backup_path = [ 'pic_backup\', backup_prefix, strrep(strrep(Img_path,'\','_'),':','') ]; % �趨����·��
%     backup_path = [Img_path, 'pic_backup\'];
    if length(backup_path) > 170    % ·��̫��ʱ�Ĵ�ʩ
        backup_path = backup_path(1:170);
        disp('    ����·��̫�����ض�');
        disp(['    backup_path = ',backup_path]);
    end
    mkdir(backup_path);

    num=0;
    if(Img_dir_len>0)    % judge if there are images in this path
        for i=1:Img_dir_len  % iterate over images
            waitbar(i/Img_dir_len)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%% ��ЩͼƬ��?��?
            if(Img_dir(i).bytes<=thre_mem*1024)  %���ͼƬС�� thre_mem KB
                continue;
            end
            if(~isempty(strfind(Img_dir(i).name,'(big)'))) %�������
                continue; %��?
            end
            Img = imread([Img_path, Img_dir(i).name]); % read image            
            Img_size = size(Img);               % get size of image
            if (Img_size(1)<=thre_size && Img_size(2)<=thre_size)  % if size is too small, skip
                continue;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% ��ЩͼƬ��?��?
            
            % ȷ�����ű���
            target_size_long = img_long_set;  %���߳�����СΪ1600
            if(~isempty(strfind(Img_dir(i).name,'(med)'))) %�������
                target_size_long = img_long_set_1;  %���߳�����СΪ2400
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
            
            % ͼƬ����
            Img_Output = imresize(Img,k*[Img_size(1) Img_size(2)]);       % ���߳ߴ��Ϊ1600
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
                % ����������ɫλ������
                % �ᱨ���error����UINT16 image data requires bitdepth specifically set to either 12 or 16.���������Ӹ��ж� 
%                 imwrite(Img_Output,[Img_path, Img_dir(i).name], 'BitDepth', 8);  % save the new image
                Img_Output = uint8((Img_Output + 128) / 256);
                % MATLAB�������ɫ���ܷ����ı䣬��win��ͼ���ѹ���򲻻ᡣ
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





%% �����������һ��ָ��ͼƬѹ����
if(0)
    Img_path = 'F:\JYZ_Memory\03 ��ѧ\2018-03~2018-08 ����2\��1����x';
    Img_name = '2018-03-02 081718 ����??jpg';
    Size_of_LongerSide = 1600;  %���߳�����СΪ1600

    Img = imread([Img_path, Img_name]);%��ͼ
    Img_size = size(Img);  %��ó�?
    if(Img_size(1)>=Img_size(2))
        k = min( 1 , Size_of_LongerSide/Img_size(1) );
    else
        k = min( 1 , Size_of_LongerSide/Img_size(2) );
    end
    if(k<=1)
        Img_Output = imresize(Img,k*[Img_size(1) Img_size(2)]); %���߳ߴ��Ϊ1600
        imwrite(Img_Output,[Img_path, Img_name]);  %����ͼƬ
    end

    disp('OK');
end
