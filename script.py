import sys
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)

# Sample DataFrame example
df = glueContext.createDataFrame(
    [(1, "John"), (2, "Jane"), (3, "Joe")],
    ["id", "name"]
)

# Show DataFrame contents
df.show()

# Save DataFrame to S3 (optional)
# df.write.mode("overwrite").csv("s3://your-target-bucket/output/")
