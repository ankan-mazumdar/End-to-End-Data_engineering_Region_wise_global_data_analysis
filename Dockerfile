FROM public.ecr.aws/lambda/python:3.9
RUN pip install requests numpy pandas pyarrow awswrangler
COPY lambda_function.py ./
CMD ["lambda_function.lambda_handler"]