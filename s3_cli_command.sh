
# To copy all JSON Reference data to same location:
put your bucket name in command, for me , it is s3://de-ankan-yt-raw-us-east-1-dev
#Replace It With Your Bucket Name

C:\Users\Ankan Mazumdar\Downloads\Projects\DE Projects\dataengineering-youtube-analysis-project-main\data>aws s3 cp . s3://de-ankan-yt-raw-us-east-1-dev/yt/raw_statistics_reference_data/ --recursive --exclude "*" --include "*.json"

output-
upload: .\GB_category_id.json to s3://de-ankan-yt-raw-us-east-1-dev/yt/raw_statistics_reference_data/GB_category_id.json


# To copy all data files to its own location, following Hive-style patterns:
aws s3 cp CAvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=ca/
aws s3 cp DEvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=de/
aws s3 cp FRvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=fr/
aws s3 cp GBvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=gb/
aws s3 cp INvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=in/
aws s3 cp JPvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=jp/
aws s3 cp KRvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=kr/
aws s3 cp MXvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=mx/
aws s3 cp RUvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=ru/
aws s3 cp USvideos.csv s3://de-ankan-yt-raw-us-east-1-dev/youtube/raw_statistics/region=us/

#
aws iam put-user-policy --user-name YOUR_USER_NAME --policy-name LambdaLayerPolicy --policy-document file://lambda_layer_policy.json
aws iam put-user-policy --user-name ankan-project-2 --policy-name LambdaLayerPolicy --policy-document file://lambda_layer_policy.json

(venv) C:\Users\Ankan Mazumdar\Downloads\Projects\DE Projects\dataengineering-youtube-analysis-project-main>aws lambda list-layers --region us-east-1
{
    "Layers": [
        {
            "LayerName": "AWSDataWrangler-Python38",
            "LayerArn": "arn:aws:lambda:us-east-1:339712989977:layer:AWSDataWrangler-Python38",
            "LatestMatchingVersion": {
                "LayerVersionArn": "arn:aws:lambda:us-east-1:339712989977:layer:AWSDataWrangler-Python38:1",
                "Version": 1,
                "Description": "AWS Data Wrangler Lambda Layer - 2.16.1 (Python 3.8)",
                "CreatedDate": "2024-06-04T22:40:25.180+0000",
                "CompatibleRuntimes": [
                    "python3.8"
                ],
                "LicenseInfo": "Apache 2.0"
            }
        },

Docker commands-
Step 1: Create a new repository in ECR
aws ecr create-repository --repository-name my-lambda-repo-demo

Step 2: Create a file with name Dockerfile and write below commands inside it-
FROM public.ecr.aws/lambda/python:3.9
RUN pip install requests numpy pandas pyarrow awswrangler
COPY lambda_function.py ./
CMD ["lambda_function.lambda_handler"]

Step 3: Create Docker image
docker build -t my-lambda-image .

Step 4: Authenticate Docker with ECR
aws ecr get-login-password --region ‹region> | docker login --username AWS --password-stdin <account id>.dkr.ecr.us-east-2.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 339712989977.dkr.ecr.us-east-1.amazonaws.com

GET ACCOUNT ID IF MISSING:
aws sts get-caller-identity --query Account --output text
(venv) C:\Users\Ankan Mazumdar\Downloads\Projects\DE Projects\dataengineering-youtube-analysis-project-main>aws sts get-caller-identity
{
    "UserId": "AIDAU6GDY3MMQ5WDDDZIG",
    "Account": "339712989977",
    "Arn": "arn:aws:iam::339712989977:user/ankan-project-2"
}

Step 5: Tag and Push Docker Image
Tag:
docker tag my-lambda-image:latest 339712989977.dkr.ecr.us-east-1.amazonaws.com/my-lambda-repo-demo:latest

Push:
docker push 339712989977.dkr.ecr.us-east-1.amazonaws.com/my-lambda-repo-demo:latest

envt variables-
glue_catalog_db_name	db_data_cleaned
glue_catalog_table_name	cleaned_statistics_referenced_data
s3_cleansed_layer	s3://de-ankan-yt-cleaned-us-east-1-dev/
write_data_operation	append

issues-
AWS lambda package size limit issues- Deploying AWS Lambda Functions with Docker and Amazon ECR | large 10GB packages (2023)- https://www.youtube.com/watch?v=UPkDjhhfVcY&t=112s
Permissuion , IAM roles issues- giving S3 and Glue access to the docker lambda function
change the test event key too
timeout error
creation of glue db catalog db manually - aws glue create-database --database-input "{\"Name\":\"db_data_cleaned\"}"
hive table query error
updating s3 location in cleaned table- aws glue update-table --database-name db_data_cleaned --table-input "{\"Name\":\"cleaned_statistics_referenced_data\",\"StorageDescriptor\":{\"Location\":\"s3://de-ankan-yt-cleaned-us-east-1-dev/\",\"Columns\":[]}}"


rectify json format uissye in lambda_function.py


Steps
1. Keep data type change in data catalog
2. Delete our testing JSON file
3. Confirm APPEND in Lambda
4. Run Test event in Lambda
5. Cappy a (AWSCLidata, from our
6. Add the S3 Trigger to Lambda

pyspark_code.py , put all the Athena source  table path and target bucket path


disable Quick sight auto purchase