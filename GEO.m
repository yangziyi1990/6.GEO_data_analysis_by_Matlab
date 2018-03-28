% gseData = getgeodata('GSE5847', 'ToFile', 'GSE5847.txt')
X=gseData.Data;
H=gseData.Header;
get(gseData.Data)
gseData.Data(1:5,1:5);
gseData.Header.Series;
gseData.Header.Samples.data_processing(1);
sampleSources = unique(gseData.Header.Samples.source_name_ch1);  % sample class
sampleGrp = gseData.Header.Samples.characteristics_ch1(1,:);


%% 获取GEO平台（GPL）数据
gse96=getgeodata('GPL96','ToFile','GPL96.txt')
gplData = geosoftread('GPL96.txt');
gplProbesetIDs = gplData.Data(:, strcmp(gplData.ColumnNames, 'ID'));
geneSymbols = gplData.Data(:, strcmp(gplData.ColumnNames, 'Gene Symbol'));
gseData.Data = rownames(gseData.Data, ':', geneSymbols);  % 注意 data中的名称是否和平台上的探针顺序一致

%% data analysis
stromaIdx = strcmpi(sampleSources{1}, gseData.Header.Samples.source_name_ch1);  % 采样类别
nStroma = sum(stromaIdx)  % human breast cancer stroma采样类别的数量
stromaData = gseData.Data(:, stromaIdx);
stromaGrp = sampleGrp(stromaIdx);  % 分类 IBC 和 non-IBC
nStromaIBC = sum(strcmp('IBC', stromaGrp)); % IBC数量
nStromaNonIBC = sum(strcmp('non-IBC', stromaGrp)); % non-IBC数量
stromaData = colnames(stromaData, ':', stromaGrp); % 用样本分组标签来标记列

%% 显示一个具体基因的归一化基因表达值的直方图，可用于研究这些基因表达值的分布
fID = 331:339;
zValues = zscore(stromaData.(':')(':'), 0, 2);
bw = 0.25;
edges = -10:bw:10;
bins = edges(1:end-1) + diff(edges)/2;
histStroma = histc(zValues(fID, :)', edges) ./ (stromaData.NCols*bw);
figure;
for i = 1:length(fID)

    subplot(3,3,i);
    bar(edges, histStroma(:,i), 'histc')
    xlim([-3 3])
    if i <= length(fID)-3
        set(gca, 'XtickLabel', [])
    end
    title(sprintf('gene%d - %s', fID(i), stromaData.RowNames{fID(i)}))

end

suptitle('Gene Expression Value Distributions')

%% 可以利用genevarfilter函数来滤除样本简变异较小的基因
[mask, stromaData] = genevarfilter(stromaData);

%% 对每个基因进行一次t检验并比较其p值，通过随机替换样本（本例替换1，000次）发现在IBC和非IBC肿瘤之间显著地差异表达的基因。
randn('state', 0)
[pvalues, tscores]=mattest(stromaData(:, 'diagnosis: IBC'), stromaData(:, 'diagnosis: non-IBC'),...
                           'Showhist', true', 'showplot', true, 'permute', 1000);

% 排序并列出前20个基因
testResults = [pvalues, tscores];
testResults = sortrows(testResults);
testResults(1:20, :)

