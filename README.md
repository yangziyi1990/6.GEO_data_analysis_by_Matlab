# 6.GEO_data_analysis_by_Matlab

https://blog.csdn.net/hugeheadhuge/article/details/6439978
官网：https://www.mathworks.com/help/bioinfo/examples/working-with-geo-series-data.html

# 本文讨论Matlab生物信息学工具箱用于获取并处理NCBI基因表达数据库（GEO）系列数据集的新功能。

引言
NCBI基因表达数据库是存储高通量微阵列实验数据最大的公共数据库，包括四种实体类：GEO平台（GPL）、GEO样本（GSM）、GEO系列（GSE）和修订GEO数据集（GDS）。
一条平台记录描述了实验所用芯片的元件列表如：cDNAs、寡核苷酸探针集等，每个平台记录拥有一个唯一、稳定的GEO存取号（GPLxxx）。
一条样本记录描述每个样本的处理条件、操作、每个元件的丰度测量值，每个样本记录拥有一个唯一、稳定的GEO存取号（GSMxxx）。
一条系列记录定义了一组相关的样本并提供了整个研究的焦点和描述信息，也包含描述提取数据的表、概要结论或分析，每个系列记录拥有一个唯一、稳定的GEO存取号（GSExxx）。
一条数据集记录（GDSxxx）代表一个生物学和统计学可比较的GEO样本的集合，GEO数据集是GEO样本数据的修订集。
Matlab生物信息学工具箱提供了获取并解析GEO格式数据文件的函数，GSE, GSM, GSD和GPL数据可以通过调用getgeodata函数获取，该函数也能将获取的数据保存到一个文本文件中，GEO系列记录可以SOFT格式文件和制表符分割的文本格式文件获得，可以用geoseriesread函数读取GEO系列文本格式文件，用geosoftread函数读取通常相当大的SOFT格式文件。
本文用实例演示如何调用这些函数获取并解析GEO系列数据，以获取GSE5847数据集为例，进行统计分析， 该数据集包括15个发炎引起的乳腺癌（IBC）病例和35个非发炎引起的乳腺癌病例的肿瘤基质和上皮细胞的实验数据。（Boersma et al. 2008）

# 获取GEO系列数据
函数getgeodata返回一个数据结构包含来自GEO数据库的数据，可本地保存这些数据用于下一步的Matlab子程序，用geoseriesread解析GSE文本格式文件。
gseData = getgeodata('GSE5847', 'ToFile', 'GSE5847.txt')
gseData =
      Header: [1x1 struct]
      Data: [22283x95 bioma.data.DataMatrix]
 
该数据结构包含一个Header 域保存系列数据的元数据，一个数据域保存系列矩阵数据。

# 探索GSE数据
数据域中的GSE5847矩阵数据以DataMatrix对象存储，该对象类似于Matlab二维阵列数据结构，但增加了行名、列名等附加的元数据，这些对象的属性可以象其它Matlab对象一样存取。
get(gseData.Data)
            Name: ''
        RowNames: {22283x1 cell}
        ColNames: {1x95 cell}
           NRows: 22283
           NCols: 95
           NDims: 2
    ElementClass: 'double'
行名是芯片探针集的标识符，列名是GEO样本存取号。
gseData.Data(1:5, 1:5)
ans =
                 GSM136326    GSM136327    GSM136328    GSM136329    GSM136330
    1007_s_at     10.45       9.3995       9.4248       9.4729       9.2788  
    1053_at      5.7195       4.8493       4.7321       4.7289       5.3264  
    117_at       5.9387       6.0833        6.448       6.1769       6.5446  
    121_at       8.0231       7.8947        8.345       8.1632        8.2338  
    1255_g_at    3.9548       3.9632       3.9641       4.0878       3.9989  
系列元数据存储于Header域，其中Header.Series域包含系列信息，Header.Sample域包含样本信息。
gseData.Header
ans =
     Series: [1x1 struct]
    Samples: [1x1 struct]
系列域包含实验名称和芯片GEO平台ID。
gseData.Header.Series
ans =
                         title: 'Tumor and stroma from breast by LCM'
                 geo_accession: 'GSE5847'
                        status: 'Public on Sep 30 2007'
               submission_date: 'Sep 15 2006'
              last_update_date: 'Jan 24 2008'
                     pubmed_id: '17999412'
                        summary: [1x250 char]
                overall_design: [1x205 char]
                   contributor: [1x42 char]
                     sample_id: [1x950 char]
                  contact_name: 'Stefan,,Ambs'
            contact_laboratory: 'LHC'
             contact_institute: 'NCI'
               contact_address: '37 Convent Dr Bldg 37 Room 3050'
                  contact_city: 'Bethesda'
                 contact_state: 'MD'
    contact_zip0x2Fpostal_code: '20892'
               contact_country: 'USA'
             supplementary_file: 'ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/series/GSE5847/GSE5847_RAW.tar'
                   platform_id: 'GPL96'
gseData.Header.Samples
ans =
                         title: {1x95 cell}
                 geo_accession: {1x95 cell}
                        status: {1x95 cell}
               submission_date: {1x95 cell}
              last_update_date: {1x95 cell}
                          type: {1x95 cell}
                 channel_count: {1x95 cell}
               source_name_ch1: {1x95 cell}
                  organism_ch1: {1x95 cell}
           characteristics_ch1: {2x95 cell}
                  molecule_ch1: {1x95 cell}
          extract_protocol_ch1: {1x95 cell}
                     label_ch1: {1x95 cell}
            label_protocol_ch1: {1x95 cell}
                  hyb_protocol: {1x95 cell}
                 scan_protocol: {1x95 cell}
                   description: {1x95 cell}
               data_processing: {1x95 cell}
                   platform_id: {1x95 cell}
                   contact_name: {1x95 cell}
            contact_laboratory: {1x95 cell}
             contact_institute: {1x95 cell}
               contact_address: {1x95 cell}
                  contact_city: {1x95 cell}
                 contact_state: {1x95 cell}
    contact_zip0x2Fpostal_code: {1x95 cell}
               contact_country: {1x95 cell}
            supplementary_file: {1x95 cell}
                data_row_count: {1x95 cell}
数据处理域包含数据处理方法信息，本例中为鲁棒的多芯片平均算法（RMA）。
gseData.Header.Samples.data_processing(1)
ans =
    'RMA'
样本来源储存在source_name_ch1域。
sampleSources = unique(gseData.Header.Samples.source_name_ch1);
sampleSources{:}
ans =
human breast cancer stroma
ans =
human breast cancer tumor epithelium
样本特征储存在Header.Samples.characteristics_ch1域。
gseData.Header.Samples.characteristics_ch1(:,1)
ans =
    'IBC'
    'Deceased'
可以将Header.Samples.characteristics_ch1域用作区分样本是IBC还是非IBC的分组标签。
sampleGrp = gseData.Header.Samples.characteristics_ch1(1,:);
获取GEO平台（GPL）数据
由系列元数据可知本实验的芯片平台ID为GPL96，这是一种Affymetrix公司出品的人类基因组芯片HG-U133A，可以用getgeodata函数从GEO获取GPL96的 SOFT格式文件，如使用getgeodata函数获取GPL96平台文件保存为文本文件GPLE96.txt后可用geosoftread函数解析该SOFT格式文件。
gplData = geosoftread('GPL96.txt')
gplData =
                 Scope: 'PLATFORM'
             Accession: 'GPL96'
                Header: [1x1 struct]
    ColumnDescriptions: {16x1 cell}
           ColumnNames: {16x1 cell}
                  Data: {22283x16 cell}
数据的列名包含在gplData数据结构的ColumnNames域。
gplData.ColumnNames
ans =
    'ID'
    'GB_ACC'
    'SPOT_ID'
    'Species Scientific Name'
    'Annotation Date'
    'Sequence Type'
    'Sequence Source'
    'Target Description'
    'Representative Public ID'
    'Gene Title'
    'Gene Symbol'
    'ENTREZ_GENE_ID'
    'RefSeq Transcript ID'
    'Gene Ontology Biological Process'
    'Gene Ontology Cellular Component'
    'Gene Ontology Molecular Function'
可以从该平台数据中获得探针集的ID和基因符号。
gplProbesetIDs = gplData.Data(:, strcmp(gplData.ColumnNames, 'ID'));
geneSymbols = gplData.Data(:, strcmp(gplData.ColumnNames, 'Gene Symbol'));
可以用基因符号标记DataMatrix对象gseData.Data中的基因，注意来自平台文件的探针集ID可能与gseData.Data中的顺序不同，在本例中，它们是相同的。
可以将表达数据中的行名改为基因符号。
gseData.Data = rownames(gseData.Data, ':', geneSymbols);
下面显示基因符号用作行名以后的前5行5列：
gseData.Data(1:5, 1:5)
ans =
              GSM136326    GSM136327    GSM136328    GSM136329    GSM136330
    DDR1       10.45       9.3995       9.4248        9.4729       9.2788  
    RFC2      5.7195       4.8493       4.7321       4.7289       5.3264  
    HSPA6     5.9387       6.0833        6.448       6.1769       6.5446  
    PAX8      8.0231       7.8947        8.345       8.1632       8.2338  
   GUCA1A    3.9548       3.9632       3.9641       4.0878       3.9989  

# 数据分析
生物信息学工具箱提供微阵列数据分析需要的广谱分析与可视化工具，但在本文中解释这些分析方法不是我们的主要目的，因为基质细胞基因表达谱数据仅涉及很少一部分函数，更多的基因表达分析工具将另文介绍。
该实验采用来自于基质和上皮细胞的IBC和非IBC样本为试材，在这个例子中，主要利用了基质数据，由gseData.Header.Samples.source_name_ch1域确定基质细胞类型的样本类别。
stromaIdx = strcmpi(sampleSources{1}, gseData.Header.Samples.source_name_ch1);
确定基质细胞的样本数量。
nStroma = sum(stromaIdx)
nStroma =
    47
stromaData = gseData.Data(:, stromaIdx);
stromaGrp = sampleGrp(stromaIdx);
确定IBC和非IBC基质细胞样本的数量。
nStromaIBC = sum(strcmp('IBC', stromaGrp))
nStromaIBC =
    13
nStromaNonIBC = sum(strcmp('non-IBC', stromaGrp))
nStromaNonIBC =
    34
可以用样本分组标签来标记列。
stromaData = colnames(stromaData, ':', stromaGrp);
下面这个例程显示一个具体基因的归一化基因表达值的直方图，可用于研究这些基因表达值的分布。
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
 
采用Affymetrix基因芯片多达22，000个特征在相对小的样本（少于100）获得基因表达谱，在47个肿瘤基质样本中，13个属于IBC，其余34个为非IBC，但并非所有的基因都在IBC和非IBC肿瘤之间差异表达，需要通过统计检验来鉴定一个基因表达签名来区分IBC和非IBC样本。
可以利用genevarfilter函数来滤除样本简变异较小的基因。
[mask, stromaData] = genevarfilter(stromaData);
stromaData.NRows
ans =
       20055
对每个基因进行一次t检验并比较其p值，通过随机替换样本（本例替换1，000次）发现在IBC和非IBC肿瘤之间显著地差异表达的基因。
randn('state', 0)
[pvalues, tscores]=mattest(stromaData(:, 'IBC'), stromaData(:, 'non-IBC'),...
                           'Showhist', true', 'showplot', true, 'permute', 1000);

 
按指定的p值选择基因。
sum(pvalues < 0.001)
ans =
    50
在p-values < 0.001标准下有50个差异表达的基因。
排序并列出前20个基因。
testResults = [pvalues, tscores];
testResults = sortrows(testResults);
testResults(1:20, :)
ans =
               p-values       t-scores
    INPP5E     2.6288e-005     5.0389
    ARFRP1     3.1863e-005     4.9753
    USP46      3.9311e-005    -4.9054
    GOLGB1     5.5976e-005    -4.7928
    TTC3        0.00012541    -4.5053
    THUMPD1     0.00015608    -4.4317
                0.00018588     4.3656
    MAGED2      0.00019701    -4.3444
    DNAJB9      0.00020658    -4.3266
    KIF1C       0.00025783     4.2504
                0.00025932    -4.2482
    DZIP3       0.00026121    -4.2454
    COPB1       0.00026891    -4.2332
    PSD3        0.00028597    -4.2138
    PLEKHA4     0.00030759      4.186
    DNAJB9      0.00032057    -4.1708
    TMEM4       0.00032328    -4.1672
    USP9X        0.0003273    -4.1619
    SEC22B       0.0003472    -4.1392
    GFER        0.00035003    -4.1352
 
References
[1] Boersma, B.J., Reimers, M., Yi, M., Ludwig, J.A., et al. (2008). A stromal gene signature associated with inflammatory breast cancer. Int J Cancer 15;122(6), 1324-1332.
