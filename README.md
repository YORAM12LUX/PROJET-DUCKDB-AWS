
# DuckDB sur AWS avec   Terraform

Ce projet déploie une instance EC2 sur AWS avec DuckDB installé, et interroge un fichier CSV stocké dans un bucket S3 public. Le tout est automatisé avec Terraform.





## Preréquis

- AWS CLI

- Terraform

- Une clé SSH pour se connecter à l'EC2 (ou en générer une avec ssh-keygen) en local

- Un compte AWS (IAM user avec accès programmatique recommandé)

## Configuration AWS

1. **Créer un utilisateur IAM**


- Dans la conole IAM  sur AWS 

Crée un nouvel utilisateur avec :

Nom : duckdb-user

Accès : Accès programmatique

Permissions : AmazonS3FullAccess, AmazonEC2FullAccess, IAMFullAccess


2. **Configurer AWS CLI avec ce profil**


```bash
  aws configure --profile duckdb
```

Remplir : ( On crée une clé d'accès sur AWS et obtient les credentials )

Renseigne les Access Key / Secret

Choisis une région, par ex : eu-west-3


## Structure du projet




```bash
DuckDB_AWS_Terraform_PRJ/

  ├── data/
      └── fichier.csv
  ├── terraform
      └── main.tf            # Fichier principal Terraform
      └── variables.tf       # Variables Terraform
      └── outputs.tf         # Renvoye l'IP pubique de l'EC2 et le nom du bucket S3
  |   └── terraform.tfvars
  |        
  ├── scripts/
  │   └── install_duckdb.sh    # Script d'installation de DuckDB + script SQL

```







    
## 🏗️ Déploiement avec Terraform

Initialiser Terraform

```bash
  terrform init 
```

Faire un plan pour vérifier les ressources à créer

```bash
  terrform plan 
```

 Lancer la création de l’infrastructure sur AWS

 ```bash
  terrform apply 
```

Connexion à l'instance EC2


 ```bash
  ssh -i ~/.ssh/ma_cle.pem ec2-user@<IP_PUBLIQUE>

```
IP publique visible dans les outputs Terraform ou la console EC2


Exécution de la requête DuckDB

 ```bash
  bash ~/query.sh
  ou
  ./query.sh

```



La requête analyse le fichier CSV public depuis S3 :

```bash
SELECT Gender, AVG("Height") 
FROM read_csv_auto('https://duckdb-demo-bucket-2025.s3.amazonaws.com/hw_200.csv') 
GROUP BY Gender;


```

| Gender Varchar| avg(Height) double     
| :-------- | :------- | 
| `Male`      | `71.0` |
| `Female`      | `63.0` |

## Nettoyage des ressources

```bash
 terraform destroy 
```


Accéder au paramtre AWS :

cat ~/aws/credentials
cat ~/aws/confg

