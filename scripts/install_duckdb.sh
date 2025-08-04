#!/bin/bash

# Installer DuckDB
yum update -y
yum install -y gcc wget unzip

wget https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip -d /usr/local/bin
mv /usr/local/bin/duckdb_cli /usr/local/bin/duckdb
chmod +x /usr/local/bin/duckdb

# Script de requête automatique
cat <<EOF > /home/ec2-user/query.sh
#!/bin/bash
QUERY="SELECT Gender, AVG(Height) FROM read_csv_auto('https://duckdb-demo-bucket-2025.s3.amazonaws.com/hw_200.csv') GROUP BY Gender;"
echo \$QUERY | duckdb
EOF

chmod +x /home/ec2-user/query.sh
