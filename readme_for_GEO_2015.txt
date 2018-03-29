Fist step:
Running the script "GEO_2015.m". After that, we obtained three file in xls format. 
Adding rownames and colnamse for "*_matrix.xls" and transformed to "*_matrix.txt" file.

Second step:
Running the script "combine_gene.pl". 
The input format such as : $perl combine_gene.pl GSE11969_matrix.txt GSE11969_combine.txt. 
After that we obtained the file with unique gene, and combine with median method.
