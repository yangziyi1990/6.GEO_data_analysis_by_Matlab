# 6.GEO_data_analysis_by_Matlab

https://blog.csdn.net/hugeheadhuge/article/details/6439978 <br>
官网：https://www.mathworks.com/help/bioinfo/examples/working-with-geo-series-data.html <br>

## 本文讨论Matlab生物信息学工具箱用于获取并处理NCBI基因表达数据库（GEO）系列数据集的新功能。

引言 <br>
NCBI基因表达数据库是存储高通量微阵列实验数据最大的公共数据库，包括四种实体类：GEO平台（GPL）、GEO样本（GSM）、GEO系列（GSE）和修订GEO数据集（GDS）。<br>
一条平台记录描述了实验所用芯片的元件列表如：cDNAs、寡核苷酸探针集等，每个平台记录拥有一个唯一、稳定的GEO存取号（GPLxxx）。<br>
一条样本记录描述每个样本的处理条件、操作、每个元件的丰度测量值，每个样本记录拥有一个唯一、稳定的GEO存取号（GSMxxx）。<br>
一条系列记录定义了一组相关的样本并提供了整个研究的焦点和描述信息，也包含描述提取数据的表、概要结论或分析，每个系列记录拥有一个唯一、稳定的GEO存取号（GSExxx）。<br>
一条数据集记录（GDSxxx）代表一个生物学和统计学可比较的GEO样本的集合，GEO数据集是GEO样本数据的修订集。<br>
Matlab生物信息学工具箱提供了获取并解析GEO格式数据文件的函数，GSE, GSM, GSD和GPL数据可以通过调用getgeodata函数获取，该函数也能将获取的数据保存到一个文本文件中，GEO系列记录可以SOFT格式文件和制表符分割的文本格式文件获得，可以用geoseriesread函数读取GEO系列文本格式文件，用geosoftread函数读取通常相当大的SOFT格式文件。<br>
本文用实例演示如何调用这些函数获取并解析GEO系列数据，以获取GSE5847数据集为例，进行统计分析， 该数据集包括15个发炎引起的乳腺癌（IBC）病例和35个非发炎引起的乳腺癌病例的肿瘤基质和上皮细胞的实验数据。（Boersma et al. 2008）<br>

## 获取GEO系列数据
函数getgeodata返回一个数据结构包含来自GEO数据库的数据，可本地保存这些数据用于下一步的Matlab子程序，用geoseriesread解析GSE文本格式文件。<br>
gseData = getgeodata('GSE5847', 'ToFile', 'GSE5847.txt')<br>
gseData =<br>
      Header: [1x1 struct]<br>
      Data: [22283x95 bioma.data.DataMatrix]<br>

该数据结构包含一个Header 域保存系列数据的元数据，一个数据域保存系列矩阵数据。<br>

## 探索GSE数据
数据域中的GSE5847矩阵数据以DataMatrix对象存储，该对象类似于Matlab二维阵列数据结构，但增加了行名、列名等附加的元数据，这些对象的属性可以象其它Matlab对象一样存取。<br>
get(gseData.Data)<br>
            Name: ''<br>
        RowNames: {22283x1 cell}<br>
        ColNames: {1x95 cell}<br>
           NRows: 22283<br>
           NCols: 95<br>
           NDims: 2<br>
    ElementClass: 'double'<br>
行名是芯片探针集的标识符，列名是GEO样本存取号。<br>
gseData.Data(1:5, 1:5)<br>
ans =<br>
                 GSM136326    GSM136327    GSM136328    GSM136329    GSM136330<br>
    1007_s_at     10.45       9.3995       9.4248       9.4729       9.2788  <br>
    1053_at      5.7195       4.8493       4.7321       4.7289       5.3264  <br>
    117_at       5.9387       6.0833        6.448       6.1769       6.5446  <br>
    121_at       8.0231       7.8947        8.345       8.1632        8.2338  <br>
    1255_g_at    3.9548       3.9632       3.9641       4.0878       3.9989  <br>
系列元数据存储于Header域，其中Header.Series域包含系列信息，Header.Sample域包含样本信息。<br>
gseData.Header<br>
ans =<br>
     Series: [1x1 struct]<br>
    Samples: [1x1 struct]<br>
系列域包含实验名称和芯片GEO平台ID。<br>
gseData.Header.Series<br>
ans =<br>
                         title: 'Tumor and stroma from breast by LCM'<br>
                 geo_accession: 'GSE5847'<br>
                        status: 'Public on Sep 30 2007'<br>
               submission_date: 'Sep 15 2006'<br>
              last_update_date: 'Jan 24 2008'<br>
                     pubmed_id: '17999412'<br>
                        summary: [1x250 char]<br>
                overall_design: [1x205 char]<br>
                   contributor: [1x42 char]<br>
                     sample_id: [1x950 char]<br>
                  contact_name: 'Stefan,,Ambs'<br>
            contact_laboratory: 'LHC'<br>
             contact_institute: 'NCI'<br>
               contact_address: '37 Convent Dr Bldg 37 Room 3050'<br>
                  contact_city: 'Bethesda'<br>
                 contact_state: 'MD'<br>
    contact_zip0x2Fpostal_code: '20892'<br>
               contact_country: 'USA'<br>
             supplementary_file: 'ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/series/GSE5847/GSE5847_RAW.tar'<br>
                   platform_id: 'GPL96'<br>
gseData.Header.Samples<br>
ans =<br>
                         title: {1x95 cell}<br>
                 geo_accession: {1x95 cell}<br>
                        status: {1x95 cell}<br>
               submission_date: {1x95 cell}<br>
              last_update_date: {1x95 cell}<br>
                          type: {1x95 cell}<br>
                 channel_count: {1x95 cell}<br>
               source_name_ch1: {1x95 cell}<br>
                  organism_ch1: {1x95 cell}<br>
           characteristics_ch1: {2x95 cell}<br>
                  molecule_ch1: {1x95 cell}<br>
          extract_protocol_ch1: {1x95 cell}<br>
                     label_ch1: {1x95 cell}<br>
            label_protocol_ch1: {1x95 cell}<br>
                  hyb_protocol: {1x95 cell}<br>
                 scan_protocol: {1x95 cell}<br>
                   description: {1x95 cell}<br>
               data_processing: {1x95 cell}<br>
                   platform_id: {1x95 cell}<br>
                   contact_name: {1x95 cell}<br>
            contact_laboratory: {1x95 cell}<br>
             contact_institute: {1x95 cell}<br>
               contact_address: {1x95 cell}<br>
                  contact_city: {1x95 cell}<br>
                 contact_state: {1x95 cell}<br>
    contact_zip0x2Fpostal_code: {1x95 cell}<br>
               contact_country: {1x95 cell}<br>
            supplementary_file: {1x95 cell}<br>
                data_row_count: {1x95 cell}<br>
数据处理域包含数据处理方法信息，本例中为鲁棒的多芯片平均算法（RMA）。<br>
gseData.Header.Samples.data_processing(1)<br>
ans =<br>
    'RMA'<br>
样本来源储存在source_name_ch1域。<br>
sampleSources = unique(gseData.Header.Samples.source_name_ch1);<br>
sampleSources{:}<br>
ans =<br>
human breast cancer stroma<br>
ans =<br>
human breast cancer tumor epithelium<br>
样本特征储存在Header.Samples.characteristics_ch1域。<br>
gseData.Header.Samples.characteristics_ch1(:,1)<br>
ans =<br>
    'IBC'<br>
    'Deceased'<br>
可以将Header.Samples.characteristics_ch1域用作区分样本是IBC还是非IBC的分组标签。<br>
sampleGrp = gseData.Header.Samples.characteristics_ch1(1,:);<br>
## 获取GEO平台（GPL）数据
由系列元数据可知本实验的芯片平台ID为GPL96，这是一种Affymetrix公司出品的人类基因组芯片HG-U133A，可以用getgeodata函数从GEO获取GPL96的 SOFT格式文件，如使用getgeodata函数获取GPL96平台文件保存为文本文件GPLE96.txt后可用geosoftread函数解析该SOFT格式文件。<br>
gplData = geosoftread('GPL96.txt')<br>
gplData =<br>
                 Scope: 'PLATFORM'<br>
             Accession: 'GPL96'<br>
                Header: [1x1 struct]<br>
    ColumnDescriptions: {16x1 cell}<br>
           ColumnNames: {16x1 cell}<br>
                  Data: {22283x16 cell}<br>
数据的列名包含在gplData数据结构的ColumnNames域。<br>
gplData.ColumnNames<br>
ans =<br>
    'ID'<br>
    'GB_ACC'<br>
    'SPOT_ID'<br>
    'Species Scientific Name'<br>
    'Annotation Date'<br>
    'Sequence Type'<br>
    'Sequence Source'<br>
    'Target Description'<br>
    'Representative Public ID'<br>
    'Gene Title'<br>
    'Gene Symbol'<br>
    'ENTREZ_GENE_ID'<br>
    'RefSeq Transcript ID'<br>
    'Gene Ontology Biological Process'<br>
    'Gene Ontology Cellular Component'<br>
    'Gene Ontology Molecular Function'<br>
可以从该平台数据中获得探针集的ID和基因符号。<br>
gplProbesetIDs = gplData.Data(:, strcmp(gplData.ColumnNames, 'ID'));<br>
geneSymbols = gplData.Data(:, strcmp(gplData.ColumnNames, 'Gene Symbol'));<br>
可以用基因符号标记DataMatrix对象gseData.Data中的基因，注意来自平台文件的探针集ID可能与gseData.Data中的顺序不同，在本例中，它们是相同的。
可以将表达数据中的行名改为基因符号。<br>
gseData.Data = rownames(gseData.Data, ':', geneSymbols);<br>
下面显示基因符号用作行名以后的前5行5列：<br>
gseData.Data(1:5, 1:5)<br>
ans =<br>
              GSM136326    GSM136327    GSM136328    GSM136329    GSM136330<br>
    DDR1       10.45       9.3995       9.4248        9.4729       9.2788  <br>
    RFC2      5.7195       4.8493       4.7321       4.7289       5.3264  <br>
    HSPA6     5.9387       6.0833        6.448       6.1769       6.5446  <br>
    PAX8      8.0231       7.8947        8.345       8.1632       8.2338  <br>
   GUCA1A    3.9548       3.9632       3.9641       4.0878       3.9989  <br>

## 数据分析
生物信息学工具箱提供微阵列数据分析需要的广谱分析与可视化工具，但在本文中解释这些分析方法不是我们的主要目的，因为基质细胞基因表达谱数据仅涉及很少一部分函数，更多的基因表达分析工具将另文介绍。<br>
该实验采用来自于基质和上皮细胞的IBC和非IBC样本为试材，在这个例子中，主要利用了基质数据，由gseData.Header.Samples.source_name_ch1域确定基质细胞类型的样本类别。<br>
stromaIdx = strcmpi(sampleSources{1}, gseData.Header.Samples.source_name_ch1);<br>
确定基质细胞的样本数量。<br>
nStroma = sum(stromaIdx)<br>
nStroma =<br>
    47<br>
stromaData = gseData.Data(:, stromaIdx);<br>
stromaGrp = sampleGrp(stromaIdx);<br>
确定IBC和非IBC基质细胞样本的数量。<br>
nStromaIBC = sum(strcmp('IBC', stromaGrp))<br>
nStromaIBC =<br>
    13<br>
nStromaNonIBC = sum(strcmp('non-IBC', stromaGrp))<br>
nStromaNonIBC =<br>
    34<br>
可以用样本分组标签来标记列。<br>
stromaData = colnames(stromaData, ':', stromaGrp);<br>
下面这个例程显示一个具体基因的归一化基因表达值的直方图，可用于研究这些基因表达值的分布。<br>
fID = 331:339;<br>
zValues = zscore(stromaData.(':')(':'), 0, 2);<br>
bw = 0.25;<br>
edges = -10:bw:10;<br>
bins = edges(1:end-1) + diff(edges)/2;<br>
histStroma = histc(zValues(fID, :)', edges) ./ (stromaData.NCols*bw);<br>
figure;<br>
for i = 1:length(fID)<br>
    subplot(3,3,i);<br>
    bar(edges, histStroma(:,i), 'histc')<br>
    xlim([-3 3])<br>
    if i <= length(fID)-3<br>
        set(gca, 'XtickLabel', [])<br>
    end<br>
    title(sprintf('gene%d - %s', fID(i), stromaData.RowNames{fID(i)}))<br>
end<br>
suptitle('Gene Expression Value Distributions')<br>
 
采用Affymetrix基因芯片多达22，000个特征在相对小的样本（少于100）获得基因表达谱，在47个肿瘤基质样本中，13个属于IBC，其余34个为非IBC，但并非所有的基因都在IBC和非IBC肿瘤之间差异表达，需要通过统计检验来鉴定一个基因表达签名来区分IBC和非IBC样本。<br>
可以利用genevarfilter函数来滤除样本简变异较小的基因。<br>
[mask, stromaData] = genevarfilter(stromaData);<br>
stromaData.NRows<br>
ans =<br>
       20055<br>
对每个基因进行一次t检验并比较其p值，通过随机替换样本（本例替换1，000次）发现在IBC和非IBC肿瘤之间显著地差异表达的基因。<br>
randn('state', 0)<br>
[pvalues, tscores]=mattest(stromaData(:, 'IBC'), stromaData(:, 'non-IBC'),...<br>
                           'Showhist', true', 'showplot', true, 'permute', 1000);<br>

 
按指定的p值选择基因。<br>
sum(pvalues < 0.001)<br>
ans =<br>
    50<br>
在p-values < 0.001标准下有50个差异表达的基因。<br>
排序并列出前20个基因。<br>
testResults = [pvalues, tscores];<br>
testResults = sortrows(testResults);<br>
testResults(1:20, :)<br>
ans =<br>
               p-values       t-scores<br>
    INPP5E     2.6288e-005     5.0389<br>
    ARFRP1     3.1863e-005     4.9753<br>
    USP46      3.9311e-005    -4.9054<br>
    GOLGB1     5.5976e-005    -4.7928<br>
    TTC3        0.00012541    -4.5053<br>
    THUMPD1     0.00015608    -4.4317<br>
                0.00018588     4.3656<br>
    MAGED2      0.00019701    -4.3444<br>
    DNAJB9      0.00020658    -4.3266<br>
    KIF1C       0.00025783     4.2504<br>
                0.00025932    -4.2482<br>
    DZIP3       0.00026121    -4.2454<br>
    COPB1       0.00026891    -4.2332<br>
    PSD3        0.00028597    -4.2138<br>
    PLEKHA4     0.00030759      4.186<br>
    DNAJB9      0.00032057    -4.1708<br>
    TMEM4       0.00032328    -4.1672<br>
    USP9X        0.0003273    -4.1619<br>
    SEC22B       0.0003472    -4.1392<br>
    GFER        0.00035003    -4.1352<br>
 
References<br>
[1] Boersma, B.J., Reimers, M., Yi, M., Ludwig, J.A., et al. (2008). A stromal gene signature associated with inflammatory breast cancer. Int J Cancer 15;122(6), 1324-1332.<br>
