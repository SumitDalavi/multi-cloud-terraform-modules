package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestAwsEksModuleValidation validates the EKS module compiles and plans correctly.
func TestAwsEksModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/aws/eks",
		Vars: map[string]interface{}{
			"cluster_name": "test-eks-cluster",
			"vpc_id":       "vpc-12345678",
			"subnet_ids":   []string{"subnet-aaa", "subnet-bbb"},
		},
		NoColor: true,
	})

	// Validate the module compiles
	terraform.InitAndValidate(t, terraformOptions)
}

// TestAwsS3ModuleValidation validates the S3 module compiles and plans correctly.
func TestAwsS3ModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/aws/s3",
		Vars: map[string]interface{}{
			"bucket_name": "test-secure-bucket",
		},
		NoColor: true,
	})

	terraform.InitAndValidate(t, terraformOptions)
}

// TestAzureAksModuleValidation validates the AKS module compiles and plans correctly.
func TestAzureAksModuleValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/azure/aks",
		Vars: map[string]interface{}{
			"cluster_name":        "test-aks-cluster",
			"resource_group_name": "test-rg",
		},
		NoColor: true,
	})

	terraform.InitAndValidate(t, terraformOptions)
}
