package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsS3Module(t *testing.T) {
	t.Parallel()

	expectedBucketName := "test-terratest-bucket"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../modules/aws/s3",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": expectedBucketName,
			"tags": map[string]string{
				"Environment": "test",
			},
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	// defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	// For CI without AWS credentials, we will just test 'terraform init' and 'terraform plan'.
	terraform.Init(t, terraformOptions)
	planStr := terraform.Plan(t, terraformOptions)

	// We simply verify that the plan contains the bucket name, indicating the module parses correctly.
	assert.Contains(t, planStr, expectedBucketName)
}
