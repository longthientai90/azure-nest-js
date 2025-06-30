#!/usr/bin/env python3
"""
Simple test script to generate and preview Terraform templates
Only generates files, no Azure deployment
"""

import os
from terraform_service import TerraformService


def print_file_content(file_path):
    """Print file content with nice formatting"""
    if os.path.exists(file_path):
        print(f"\n{'='*80}")
        print(f"📄 FILE: {os.path.basename(file_path)}")
        print('='*80)
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            print(content)
        
        print('='*80)
    else:
        print(f"❌ File not found: {file_path}")


def test_single_company():
    """Test generation for a single company"""
    print("🧪 Testing Terraform generation for single company...")
    
    # Sample company data
    company_data = {
        "company_name": "Test Company Ltd",
        "company_slug": "test-company",
        "environment": "dev",
        "azure_region": "Southeast Asia",
        "vnet_cidr": "10.5.0.0/16",
        "public_subnet_cidr": "10.5.1.0/24",
        "private_subnet_cidr": "10.5.2.0/24",
        "db_admin_username": "testadmin",
        "api_container_image": "test-registry.azurecr.io/test/api:latest",
        "web_container_image": "test-registry.azurecr.io/test/web:latest"
    }
    
    # Initialize service
    terraform_service = TerraformService()
    
    # Generate infrastructure
    result = terraform_service.generate_company_infrastructure(company_data)
    
    if result['status'] == 'success':
        print("✅ Generation successful!")
        print(f"📂 Workspace: {result['workspace_path']}")
        print(f"📄 Generated files: {len(result['generated_files'])}")
        
        # Print generated files content
        for file_path in result['generated_files']:
            print_file_content(file_path)
            
        return result
    else:
        print(f"❌ Generation failed: {result['error_message']}")
        return None


def test_multiple_companies():
    """Test generation for multiple companies"""
    print("🧪 Testing Terraform generation for multiple companies...")
    
    companies = [
        {
            "company_name": "Alpha Corp",
            "company_slug": "alpha-corp",
            "environment": "prod",
            "azure_region": "East US",
            "vnet_cidr": "10.10.0.0/16",
            "public_subnet_cidr": "10.10.1.0/24",
            "private_subnet_cidr": "10.10.2.0/24",
            "db_admin_username": "alphaadmin",
            "api_container_image": "alpha.azurecr.io/alpha/api:v1.0.0",
            "web_container_image": "alpha.azurecr.io/alpha/web:v1.0.0"
        },
        {
            "company_name": "Beta Solutions",
            "company_slug": "beta-solutions",
            "environment": "staging",
            "azure_region": "West Europe",
            "vnet_cidr": "10.20.0.0/16",
            "public_subnet_cidr": "10.20.1.0/24",
            "private_subnet_cidr": "10.20.2.0/24",
            "db_admin_username": "betaadmin",
            "api_container_image": "beta.azurecr.io/beta/api:v2.1.0",
            "web_container_image": "beta.azurecr.io/beta/web:v2.1.0"
        }
    ]
    
    terraform_service = TerraformService()
    results = []
    
    for company_data in companies:
        print(f"\n🏢 Generating for: {company_data['company_name']}")
        result = terraform_service.generate_company_infrastructure(company_data)
        results.append(result)
        
        if result['status'] == 'success':
            print(f"✅ {company_data['company_name']} - SUCCESS")
            
            # Show only main.tf for brevity
            main_tf_path = os.path.join(result['workspace_path'], 'main.tf')
            if os.path.exists(main_tf_path):
                print(f"\n📄 Preview of main.tf (first 50 lines):")
                print("-" * 60)
                with open(main_tf_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines[:50], 1):
                        print(f"{i:2d}: {line.rstrip()}")
                    if len(lines) > 50:
                        print(f"... ({len(lines) - 50} more lines)")
                print("-" * 60)
        else:
            print(f"❌ {company_data['company_name']} - FAILED: {result['error_message']}")
    
    return results


def preview_templates():
    """Preview what templates are available"""
    print("🔍 Available Templates:")
    print("-" * 40)
    
    current_dir = os.path.dirname(os.path.abspath(__file__))
    template_dir = os.path.join(current_dir, "../terraform-modules/templates")
    if os.path.exists(template_dir):
        for file in os.listdir(template_dir):
            if file.endswith('.j2'):
                file_path = os.path.join(template_dir, file)
                print(f"📋 {file}")
                
                # Show first few lines
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()[:10]
                    for line in lines:
                        print(f"    {line.rstrip()}")
                    if len(lines) >= 10:
                        print("    ...")
                print()
    else:
        print("❌ Template directory not found!")


def main():
    """Main test function"""
    print("🧪 TERRAFORM TEMPLATE GENERATION TEST")
    print("=" * 50)
    print("🎯 Purpose: Test template generation without Azure deployment")
    print("📋 Options:")
    print("1. Preview available templates")
    print("2. Test single company generation")
    print("3. Test multiple companies generation")
    print("4. Exit")
    print("=" * 50)
    
    while True:
        try:
            choice = input("\nSelect option (1-4): ").strip()
            
            if choice == '1':
                preview_templates()
                
            elif choice == '2':
                result = test_single_company()
                if result:
                    print(f"\n📊 Summary:")
                    print(f"   Company: {result['company_name']}")
                    print(f"   Workspace: {result['workspace_path']}")
                    print(f"   State Key: {result['terraform_state_key']}")
                
            elif choice == '3':
                results = test_multiple_companies()
                success_count = len([r for r in results if r['status'] == 'success'])
                print(f"\n📊 Summary: {success_count}/{len(results)} companies generated successfully")
                
            elif choice == '4':
                print("👋 Goodbye!")
                break
                
            else:
                print("❌ Invalid option. Please select 1-4.")
                
        except KeyboardInterrupt:
            print("\n👋 Goodbye!")
            break
        except Exception as e:
            print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()
