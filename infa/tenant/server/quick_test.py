#!/usr/bin/env python3
"""
Quick test - Generate and show Terraform files for one company
"""

from terraform_service import TerraformService


def main():
    """Quick test for single company"""
    print("🚀 Quick Terraform Generation Test")
    print("=" * 50)
    
    # Test company data
    company_data = {
        "company_name": "Demo Company",
        "company_slug": "demo-company",
        "environment": "dev",
        "azure_region": "Southeast Asia",
        "vnet_cidr": "10.99.0.0/16",
        "public_subnet_cidr": "10.99.1.0/24",
        "private_subnet_cidr": "10.99.2.0/24",
        "db_admin_username": "demoadmin",
        "api_container_image": "demo.azurecr.io/demo/api:latest",
        "web_container_image": "demo.azurecr.io/demo/web:latest"
    }
    
    print(f"🏢 Company: {company_data['company_name']}")
    print(f"🏷️  Slug: {company_data['company_slug']}")
    print(f"🌍 Region: {company_data['azure_region']}")
    print(f"🔧 Environment: {company_data['environment']}")
    
    # Generate
    terraform_service = TerraformService()
    result = terraform_service.generate_company_infrastructure(company_data)
    
    if result['status'] == 'success':
        print("\n✅ Generation SUCCESS!")
        print(f"📂 Workspace: {result['workspace_path']}")
        print(f"🆔 Company ID: {result['company_id']}")
        print(f"🔑 State Key: {result['terraform_state_key']}")
        
        # Show generated files
        print(f"\n📄 Generated Files ({len(result['generated_files'])}):")
        for i, file_path in enumerate(result['generated_files'], 1):
            print(f"  {i}. {file_path}")
        
        # Show main.tf content
        main_tf_path = result['workspace_path'] + '/main.tf'
        print(f"\n📋 Content of main.tf:")
        print("=" * 80)
        
        try:
            with open(main_tf_path, 'r', encoding='utf-8') as f:
                content = f.read()
                print(content)
        except Exception as e:
            print(f"❌ Error reading file: {e}")
            
        print("=" * 80)
        
        # Show terraform.tfvars if exists
        tfvars_path = result['workspace_path'] + '/terraform.tfvars'
        try:
            with open(tfvars_path, 'r', encoding='utf-8') as f:
                print(f"\n📋 Content of terraform.tfvars:")
                print("-" * 50)
                content = f.read()
                print(content)
                print("-" * 50)
        except FileNotFoundError:
            print("ℹ️  terraform.tfvars not generated")
        except Exception as e:
            print(f"❌ Error reading terraform.tfvars: {e}")
            
    else:
        print(f"\n❌ Generation FAILED!")
        print(f"🔥 Error: {result['error_message']}")


if __name__ == "__main__":
    main()
