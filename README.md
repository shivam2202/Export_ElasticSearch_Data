# Export ElasticSearch Data
This is repo for exporting aggrgrated elastic data to different file format or sink to another storage. If you like to see more or need help in exporting data. Please feel free to contact me.


## Export to CSV
Script exports composite aggregration query result to CSV. See comments for detail information.

### Prerequisites

- [jq](https://stedolan.github.io/jq/download/)

### Steps

1. Open shell script in your favourite editor and change **elasticURL** and **initialElasticQuery** value. 

2. Run the script
   ```bash
   ./EQ-to-csv.sh >> test.csv
   ```



