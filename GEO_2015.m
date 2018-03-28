gseData1=getgeodata('GSE11969', 'ToFile', 'GSE11969.txt')
GSE11969_data=gseData1.Data;
gseData1.Header.Series % get platform_id
sampleSources = unique(gseData1.Header.Samples.source_name_ch1);  % 样本来源
sampleGrp = gseData1.Header.Samples.characteristics_ch1(1,:); % 样本分类储存在Header.Samples.characteristics_ch1域


%% 获取GEO平台（GPL）数据
gpl1=getgeodata('GPL7015','ToFile','GPL7015.txt')
gplData1 = geosoftread('GPL7015.txt');
[gene1,sample1]=size(gseData1.Data)
gplProbesetIDs = gplData1.Data(:, strcmp(gplData1.ColumnNames, 'ID'));
geneSymbols = gplData1.Data(:, strcmp(gplData1.ColumnNames, 'Gene symbol'));

% change rownames and colnames
gseData1.Data = rownames(gseData1.Data, ':', geneSymbols);  % 注意 data中的名称是否和平台上的探针顺序一致
gseData1.Data = colnames(gseData1.Data, ':', sampleGrp); % 用样本分组标签来标记列
% length(unique(rownames(gseData1.Data)));   % 有多个prob_id对应到一个gene，求median

GSE11969_matrix=gseData1.Data.double;
GSE11969_sample=gseData1.Data.colnames;
GSE11969_gene=gseData1.Data.rownames;

xlswrite('data1',GSE11969_matrix)
xlswrite('sample',GSE11969_sample)
xlswrite('gene',GSE11969_gene)