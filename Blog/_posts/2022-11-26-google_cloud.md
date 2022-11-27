---
layout: single
show_date: true
tags: alphafold colabfold google cloud
author: Rob Edwards
title: Extracting some data from Google Cloud
excerpt: "Heres a way to get some PDB files from Google cloud"
---


We are going to start by running a big query in [Google Cloud Console](https://console.cloud.google.com/welcome)

<small>Note: Google Cloud may charge you for access to services or data, and you are responsible for those charges</small>

Start by choosing `Run a query in BigQuery`

![](/assets/images/google/run_a_query.png) 

In this query, we have a list of CRC64 checksums, and we would like to get a list of PDB files that they correspond to.

We will start by uploading our data into Google Cloud. From the three dots by your project name choose `Create data set`:

![](/assets/images/google/create_dataset.png)

On the form that opens out, we need to provide some sensible answers. I usually let the data set expire so that I don't accumulate old data!

![](/assets/images/google/create_dataset2.png)


Once you have created a new data set, you need to create a table to load your data. Choose the `Create Table` option:

![](/assets/images/google/create_sql_table.png)

Now, we need to upload our file, and create a new dataset. The key things here are:

1. Upload a file
2. File format is CSV
3. Give your table a useful name
4. Auto-detect the `Schema` so that it will figure out the column types

![](/assets/images/google/upload_table.png)



Now that we have uploaded the data, we can start a query. Click on the dataset to expand it. Then click on the field name to initiate a query &em; in my case that is called `string_field_0`.

My query looks  like:

![](/assets/images/google/first_sql.png)

```sql
SELECT string_field_0 FROM `alphafold-359400.Susie_CRC64.CRC64s` LIMIT 1000
```

The first thing I do is reduce the number of results returned to 10. I can think about 10 results, but not 1,000!

So lets run this query:

```sql
SELECT string_field_0 FROM `alphafold-359400.Susie_CRC64.CRC64s` LIMIT 10
```

And the results look like this:

![](/assets/images/google/first_sql_results.png)


Now we can combine these results to get the paths to the PDB files:

```sql
SELECT sequenceChecksum, CONCAT('gs://public-datasets-deepmind-alphafold/', entryID, '-model_v', latestVersion, '.cif') as URLS from bigquery-public-data.deepmind_alphafold.metadata where sequenceChecksum in (SELECT string_field_0 FROM `alphafold-359400.Susie_CRC64.CRC64s` limit 10);
```

Which gives the results:

![](/assets/images/google/query_results2.png)


Or just the PDB files:

```sql
SELECT CONCAT(entryID, '-model_v', latestVersion, '.pdb') as PBDs, sequenceChecksum from bigquery-public-data.deepmind_alphafold.metadata where sequenceChecksum in (SELECT distinct string_field_0 FROM `alphafold-359400.Susie_CRC64.CRC64s` limit 10);
```

Which gives the results:


![](/assets/images/google/query_results3.png)



