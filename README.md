# S3 Notification Triggers

This script automates the process of setting up S3 bucket notifications with Lambda functions and SNS topics in AWS. It creates an S3 bucket, uploads a file to the bucket, creates a Lambda function, adds permissions to the Lambda function, configures an S3 event trigger, creates an SNS topic, adds permissions to the Lambda function to publish to the SNS topic, and publishes a message to the SNS topic.

## Prerequisites

* `jq`: Make sure you have `jq` installed on your system. You can install it using the following command:

    ```
    bashCopy codesudo apt-get install jq
    ```

## Usage

1. Clone the repository and navigate to the project directory.
2. Run the script using the following command:

    ```bash
    bashCopy code./s3-notification-triggers.sh
    ```

## Description

This script performs the following actions:

1. Retrieves the AWS Account ID using the AWS CLI and prints it for reference.
2. Sets the AWS region and defines the following variables:
    * `aws_region`: The AWS region to use for the resources.
    * `bucket_name`: The name of the S3 bucket to create.
    * `lambda_func_name`: The name of the Lambda function to create.
    * `role_name`: The name of the IAM role to create.
    * `email_address`: The email address to receive SNS notifications.
3. Creates an IAM role with the necessary permissions for the Lambda function. The role allows the Lambda function, S3, and SNS services to interact.
4. Attaches the required policies to the IAM role:
    * `AWSLambda_FullAccess`: Provides full access to AWS Lambda.
    * `AmazonSNSFullAccess`: Provides full access to Amazon SNS.
5. Creates an S3 bucket with the specified name using the AWS CLI.
6. Uploads a file to the created S3 bucket. (Note: This step is currently commented out in the script.)
7. Creates a Lambda function using the AWS CLI. The function is created with the specified runtime, handler, memory size, timeout, IAM role, and code package (a ZIP file).
8. Adds the necessary permissions to the S3 bucket to invoke the Lambda function when new objects are created.
9. Configures an S3 event trigger for the Lambda function. Whenever a new object is created in the specified bucket, the Lambda function will be triggered.
10. Creates an SNS topic using the AWS CLI and retrieves the topic ARN.
11. Adds publish permission to the Lambda function for the SNS topic. This allows the Lambda function to publish messages to the SNS topic.
12. Publishes a sample message to the SNS topic using the AWS CLI. This demonstrates the integration between the S3 bucket, Lambda function, and SNS topic.


<br>
<br>

## Code Explanation

```
import boto3
import json

def lambda_handler(event, context):
    # Extract relevant information from the S3 event trigger
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']

    # Perform desired operations with the uploaded file
    print(f"File '{object_key}' was uploaded to bucket '{bucket_name}'")

    # Example: Send a notification via SNS
    sns_client = boto3.client('sns')
    topic_arn = 'arn:aws:sns:us-east-1:<account-id>:s3-lambda-sns'
    sns_client.publish(
       TopicArn=topic_arn,
       Subject='S3 Object Created',
       Message=f"File '{object_key}' was uploaded to bucket '{bucket_name}'"
    )

    # Example: Trigger another Lambda function
    # lambda_client = boto3.client('lambda')
    # target_function_name = 'my-another-lambda-function'
    # lambda_client.invoke(
    #    FunctionName=target_function_name,
    #    InvocationType='Event',
    #    Payload=json.dumps({'bucket_name': bucket_name, 'object_key': object_key})
    # )

    return {
        'statusCode': 200,
        'body': json.dumps('Lambda function executed successfully')
    }
```

* The provided code is an AWS Lambda function that can be triggered by an S3 bucket event. It demonstrates the basic structure and functionality of a Lambda function that reacts to an S3 event and performs certain operations based on that event.
* The `lambda_handler` function is the entry point for the Lambda function. It takes two parameters: `event` and `context`. The `event` parameter contains information about the triggering event, such as the S3 bucket and object details. The `context` parameter provides runtime information about the Lambda function.
* Inside the `lambda_handler` function, the relevant information is extracted from the `event` parameter. The `bucket_name` and `object_key` variables store the S3 bucket name and the key (path) of the uploaded object, respectively.
* Next, the code performs desired operations with the uploaded file. In the provided example, it prints a message to the console indicating the file's upload to the specified bucket.
* Additionally, the code demonstrates an example of sending a notification via Amazon SNS (Simple Notification Service). It uses the `boto3` AWS SDK to create an SNS client and publish a message to the specified SNS topic ARN. The subject and message of the notification include the file's name and the bucket's name.
* The code also includes an example of triggering another Lambda function. However, this part is currently commented out. It showcases how you can use the `boto3` SDK to invoke another Lambda function, passing relevant information as payload in JSON format.
* Finally, the function returns a dictionary containing a `statusCode` and `body`. In this case, it returns a 200 status code and a JSON response indicating the successful execution of the Lambda function.
* Please note that to use this code, you'll need to replace `<account-id>` with your actual AWS account ID and uncomment the relevant sections if you want to send an SNS notification or trigger another Lambda function.
* Feel free to modify the code according to your specific requirements and integrate it with other AWS services as needed.


<br>

### Shell Script :


* The script starts with some basic information, such as the author's name, the date of creation, and a brief description of what the script does.
* The script is written in Bash and is intended to be executed in a Unix-like environment.
* The script sets up variables for the AWS account ID, AWS region, S3 bucket name, Lambda function name, IAM role name, and email address.
* It then creates an IAM role using the `aws iam create-role` command. The role has a trust policy that allows AWS Lambda, S3, and SNS services to assume the role.
* The script attaches two policies (`AWSLambda_FullAccess` and `AmazonSNSFullAccess`) to the IAM role using the `aws iam attach-role-policy` command. These policies grant necessary permissions to the role.
* Next, the script creates an S3 bucket using the `aws s3api create-bucket` command. The bucket name is specified in the `bucket_name` variable, and the AWS region is specified in the `aws_region` variable.
* A ZIP file named `s3-lambda-function.zip` is created from the `s3-lambda-function` directory using the `zip` command. This ZIP file will be used to upload the Lambda function code.
* The script creates a Lambda function using the `aws lambda create-function` command. It specifies the AWS region, function name, runtime, handler, memory size, timeout, IAM role, and ZIP file location.
* Permissions are added to the S3 bucket to invoke the Lambda function using the `aws lambda add-permission` command. The bucket name, Lambda function name, statement ID, action, and principal are provided as parameters.
* An S3 event trigger is set up for the Lambda function using the `aws s3api put-bucket-notification-configuration` command. The bucket name, Lambda function ARN, and events are specified.
* A new SNS topic is created using the `aws sns create-topic` command. The topic name is specified, and the ARN of the created topic is saved in the `topic_arn` variable.
* The script subscribes the Lambda function to the SNS topic using the `aws sns subscribe` command. The topic ARN, protocol (email), and notification endpoint (email address) are provided.
* Finally, a message is published to the SNS topic using the `aws sns publish` command. The topic ARN, subject, and message are specified.
* Please note that some parts of the script, such as file upload and triggering another Lambda function, are commented out. You can uncomment and modify them as needed.
* Make sure to replace the `<account-id>` placeholder with your actual AWS account ID.
* That's an overview of the provided script. Let me know if you have any specific questions!

## Author

* Name: Sam Prince Franklin
* Email: [samprince.franklink2020@vitstudent.ac.in](mailto:samprince.franklink2020@vitstudent.ac.in)

## License

This project is licensed under the [MIT License](https://chat.openai.com/LICENSE).
