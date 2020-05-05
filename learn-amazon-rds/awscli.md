To create an RDS instance run the following:
```
aws rds create-db-instance \
    --engine postgres  \
    --db-instance-identifier my-postgres-instance \
    --allocated-storage 20 \
    --db-instance-class db.t2.micro \
    --vpc-security-group-ids <my-securitygroup> \
    --db-subnet-group <my-vpc> \
    --master-username postgres \
    --master-user-password amemorablepassword \
    --backup-retention-period 7 \
    --publicly-accessible
```

You can get the endpoint by running:
```
aws rds describe-db-instances
```
Please note that it will only display in the output once the instance has finished creating.

To install the Postgres 11 client use the following commands:
```
sudo apt-get install curl ca-certificates gnupg
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt install postgresql-client-11
```

You can connect to the instance using:
```
psql \
   --host=<DB instance endpoint> \
   --port=5432 \
   --username=postgres \
   --password amemorablepassword  \
```

To remove the instance run:
```
To remove the database run
Aws rds  Delete-db-instance --skip-final-snapshot --db-instance-identifier my-postgres-instance
```
