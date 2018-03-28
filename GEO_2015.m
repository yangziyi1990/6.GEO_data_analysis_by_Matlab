gseData1=getgeodata('GSE11969', 'ToFile', 'GSE11969.txt')
GSE11969_data=gseData1.Data;
gseData1.Header.Series % get platform_id
sampleSources = unique(gseData1.Header.Samples.source_name_ch1);  % ������Դ
sampleGrp = gseData1.Header.Samples.characteristics_ch1(1,:); % �������ഢ����Header.Samples.characteristics_ch1��


%% ��ȡGEOƽ̨��GPL������
gpl1=getgeodata('GPL7015','ToFile','GPL7015.txt')
gplData1 = geosoftread('GPL7015.txt');
[gene1,sample1]=size(gseData1.Data)
gplProbesetIDs = gplData1.Data(:, strcmp(gplData1.ColumnNames, 'ID'));
geneSymbols = gplData1.Data(:, strcmp(gplData1.ColumnNames, 'Gene symbol'));

% change rownames and colnames
gseData1.Data = rownames(gseData1.Data, ':', geneSymbols);  % ע�� data�е������Ƿ��ƽ̨�ϵ�̽��˳��һ��
gseData1.Data = colnames(gseData1.Data, ':', sampleGrp); % �����������ǩ�������
% length(unique(rownames(gseData1.Data)));   % �ж��prob_id��Ӧ��һ��gene����median

GSE11969_matrix=gseData1.Data.double;
GSE11969_sample=gseData1.Data.colnames;
GSE11969_gene=gseData1.Data.rownames;

xlswrite('data1',GSE11969_matrix)
xlswrite('sample',GSE11969_sample)
xlswrite('gene',GSE11969_gene)