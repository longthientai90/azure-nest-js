#!/usr/bin/env python3
"""
Multi-Tenant Infrastructure Generator
Generates Terraform configurations for multiple companies
"""

import json
import os
from terraform_service import TerraformService


def load_sample_companies():
    """Load sample company configurations for testing"""
    return [
        {
            "company_name": "ACME Corporation",
            "company_slug": "acme-corp",
            "environment": "prod",
            "azure_region": "Southeast Asia",
            "vnet_cidr": "10.0.0.0/16",
            "public_subnet_cidr": "10.0.1.0/24",
            "private_subnet_cidr": "10.0.2.0/24",
            "db_admin_username": "dbadmin",
            "api_container_image": "your-registry.azurecr.io/acme/api:latest",
            "web_container_image": "your-registry.azurecr.io/acme/web:latest"
        },
        {
            "company_name": "XYZ Technologies",
            "company_slug": "xyz-tech",
            "environment": "staging",
            "azure_region": "East US",
            "vnet_cidr": "10.1.0.0/16",
            "public_subnet_cidr": "10.1.1.0/24",
            "private_subnet_cidr": "10.1.2.0/24",
            "db_admin_username": "xyzadmin",
            "api_container_image": "xyz-registry.azurecr.io/xyz/api:v2.1.0",
            "web_container_image": "xyz-registry.azurecr.io/xyz/web:v2.1.0"
        },
        {
            "company_name": "Microsoft Corporation",
            "company_slug": "microsoft-corp",
            "environment": "prod",
            "azure_region": "West US 2",
            "vnet_cidr": "10.2.0.0/16",
            "public_subnet_cidr": "10.2.1.0/24",
            "private_subnet_cidr": "10.2.2.0/24",
            "db_admin_username": "msadmin",
            "api_container_image": "microsoft.azurecr.io/ms/api:latest",
            "web_container_image": "microsoft.azurecr.io/ms/web:latest"
        }
    ]


def print_banner():
    """Print application banner"""
    print("=" * 80)
    print("🏗️  MULTI-TENANT INFRASTRUCTURE GENERATOR")
    print("=" * 80)
    print("🎯 Purpose: Generate Terraform configurations for multiple companies")
    print("📋 Features: Jinja2 templating, validation, workspace management")
    print("=" * 80)
    print()


def print_menu():
    """Print interactive menu"""
    print("\n📋 Available Actions:")
    print("1. Generate infrastructure for sample companies")
    print("2. Generate infrastructure for single company")
    print("3. List all generated companies")
    print("4. Cleanup company workspace")
    print("5. Exit")
    print("-" * 50)


def get_user_company_data():
    """Get company data from user input"""
    print("\n📝 Enter company information:")
    
    company_data = {
        "company_name": input("Company Name: "),
        "company_slug": input("Company Slug (e.g., acme-corp): "),
        "environment": input("Environment (dev/staging/prod): ") or "prod",
        "azure_region": input("Azure Region (default: Southeast Asia): ") or "Southeast Asia",
        "vnet_cidr": input("VNet CIDR (default: 10.0.0.0/16): ") or "10.0.0.0/16",
        "public_subnet_cidr": input("Public Subnet CIDR (default: 10.0.1.0/24): ") or "10.0.1.0/24",
        "private_subnet_cidr": input("Private Subnet CIDR (default: 10.0.2.0/24): ") or "10.0.2.0/24",
        "db_admin_username": input("Database Admin Username (default: dbadmin): ") or "dbadmin",
        "api_container_image": input("API Container Image: "),
        "web_container_image": input("Web Container Image: ")
    }
    
    return company_data


def generate_sample_companies(terraform_service):
    """Generate infrastructure for all sample companies"""
    print("\n🚀 Generating infrastructure for sample companies...")
    
    sample_companies = load_sample_companies()
    results = []
    
    for company_data in sample_companies:
        print(f"\n{'='*60}")
        result = terraform_service.generate_company_infrastructure(company_data)
        results.append(result)
        
        if result['status'] == 'success':
            print(f"✅ {company_data['company_name']} - SUCCESS")
        else:
            print(f"❌ {company_data['company_name']} - FAILED: {result['error_message']}")
    
    return results


def generate_single_company(terraform_service):
    """Generate infrastructure for a single company"""
    try:
        company_data = get_user_company_data()
        
        if not company_data['company_name'] or not company_data['company_slug']:
            print("❌ Company name and slug are required!")
            return None
        
        print(f"\n🚀 Generating infrastructure for: {company_data['company_name']}")
        result = terraform_service.generate_company_infrastructure(company_data)
        
        return result
        
    except KeyboardInterrupt:
        print("\n⏹️  Operation cancelled by user")
        return None


def list_companies(terraform_service):
    """List all generated companies"""
    print("\n📋 Generated Companies:")
    print("-" * 80)
    
    companies = terraform_service.list_companies()
    
    if not companies:
        print("📭 No companies found")
        return
    
    for i, company in enumerate(companies, 1):
        print(f"{i}. {company['company_slug']}")
        print(f"   📂 Path: {company['workspace_path']}")
        print(f"   📅 Last Modified: {company['last_modified']}")
        print()


def cleanup_company(terraform_service):
    """Cleanup a company workspace"""
    companies = terraform_service.list_companies()
    
    if not companies:
        print("📭 No companies to cleanup")
        return
    
    print("\n🗑️  Available companies to cleanup:")
    for i, company in enumerate(companies, 1):
        print(f"{i}. {company['company_slug']}")
    
    try:
        choice = int(input("\nSelect company to cleanup (number): ")) - 1
        if 0 <= choice < len(companies):
            company_slug = companies[choice]['company_slug']
            confirm = input(f"⚠️  Are you sure you want to delete '{company_slug}'? (y/N): ")
            
            if confirm.lower() == 'y':
                if terraform_service.cleanup_company(company_slug):
                    print(f"✅ Successfully deleted: {company_slug}")
                else:
                    print(f"❌ Failed to delete: {company_slug}")
            else:
                print("⏹️  Cleanup cancelled")
        else:
            print("❌ Invalid selection")
    except (ValueError, KeyboardInterrupt):
        print("⏹️  Cleanup cancelled")


def main():
    """Main application entry point"""
    print_banner()
    
    # Initialize Terraform Service
    try:
        terraform_service = TerraformService()
        print("✅ Terraform service initialized successfully")
    except Exception as e:
        print(f"❌ Failed to initialize Terraform service: {e}")
        return
    
    # Interactive menu loop
    while True:
        try:
            print_menu()
            choice = input("Select an option (1-5): ").strip()
            
            if choice == '1':
                results = generate_sample_companies(terraform_service)
                
                # Print summary
                success_count = len([r for r in results if r['status'] == 'success'])
                total_count = len(results)
                print(f"\n📊 Summary: {success_count}/{total_count} companies generated successfully")
                
            elif choice == '2':
                result = generate_single_company(terraform_service)
                if result:
                    if result['status'] == 'success':
                        print(f"✅ Infrastructure generated successfully!")
                        print(f"📂 Workspace: {result['workspace_path']}")
                    else:
                        print(f"❌ Generation failed: {result['error_message']}")
                
            elif choice == '3':
                list_companies(terraform_service)
                
            elif choice == '4':
                cleanup_company(terraform_service)
                
            elif choice == '5':
                print("\n👋 Goodbye!")
                break
                
            else:
                print("❌ Invalid option. Please select 1-5.")
                
        except KeyboardInterrupt:
            print("\n\n👋 Goodbye!")
            break
        except Exception as e:
            print(f"❌ An error occurred: {e}")


if __name__ == "__main__":
    main()