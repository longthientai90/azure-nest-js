# Multi-Tenant Infrastructure Generator

🏗️ **Automated Terraform configuration generator for multi-tenant Azure infrastructure**

## 📋 Features

- ✅ **Jinja2 Template Rendering**: Dynamic Terraform configuration generation
- ✅ **Multi-Company Support**: Isolated infrastructure for each company
- ✅ **Input Validation**: CIDR validation and required field checking
- ✅ **Workspace Management**: Automatic workspace creation and cleanup
- ✅ **Interactive CLI**: User-friendly command-line interface

## 🚀 Quick Start

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your Azure credentials
```

### 3. Run the Generator
```bash
python main.py
```

## 📁 Project Structure

```
server/
├── main.py                 # Main application entry point
├── terraform_service.py    # Core Terraform generation service
├── requirements.txt        # Python dependencies
├── .env.example           # Environment variables template
└── README.md              # This file

terraform-modules/
└── templates/
    ├── company.tf.j2      # Main Terraform template
    └── terraform.tfvars.j2 # Variables template

terraform-workspaces/      # Generated workspaces (auto-created)
├── acme-corp/
│   ├── main.tf
│   └── terraform.tfvars
├── xyz-tech/
│   ├── main.tf
│   └── terraform.tfvars
└── ...
```

## 🎯 Usage Examples

### Interactive Mode
```bash
python main.py
```

### Menu Options
1. **Generate Sample Companies** - Creates infrastructure for pre-defined companies
2. **Generate Single Company** - Interactive input for custom company
3. **List Companies** - Show all generated companies
4. **Cleanup Company** - Remove company workspace
5. **Exit** - Quit application

### Sample Company Data
```python
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
}
```

## 🔧 Generated Infrastructure

Each company gets:
- **Resource Group**: `{company-slug}-{environment}-rg`
- **Virtual Network**: `{company-slug}-{environment}-vnet`
- **Subnets**: Public and Private subnets
- **NAT Gateway**: For outbound internet access
- **PostgreSQL Database**: Managed database service
- **Storage Account**: Blob storage with containers
- **Container Apps**: API and Web applications
- **CDN**: Content delivery network
- **AI Services**: Azure Cognitive Services

## 📊 Output Example

### Success Response
```json
{
    "status": "success",
    "company_id": "f47ac10b-58cc-4372-8ee4-878e5c4ec5b7",
    "company_name": "ACME Corporation",
    "company_slug": "acme-corp",
    "workspace_path": "terraform-workspaces/acme-corp",
    "generated_files": [
        "terraform-workspaces/acme-corp/main.tf",
        "terraform-workspaces/acme-corp/terraform.tfvars"
    ],
    "terraform_state_key": "companies/acme-corp/terraform.tfstate",
    "generated_at": "2025-06-30T10:15:30.123456"
}
```

## 🔒 Security

- **Environment Variables**: Sensitive data stored in environment variables
- **State Isolation**: Each company has separate Terraform state
- **Workspace Separation**: Physical isolation between companies
- **Input Validation**: Prevents invalid configurations

## 🛠️ Development

### Add New Template Variables
1. Update `terraform_service.py` in `prepare_template_data()`
2. Add validation in `validate_company_data()`
3. Update templates in `terraform-modules/templates/`

### Custom Templates
- Place new templates in `terraform-modules/templates/`
- Use `.j2` extension for Jinja2 templates
- Reference in `terraform_service.py`

## 📝 Next Steps

After generation, you can:
1. **Review Generated Files**: Check `terraform-workspaces/{company}/`
2. **Initialize Terraform**: `cd terraform-workspaces/{company} && terraform init`
3. **Plan Infrastructure**: `terraform plan`
4. **Apply Infrastructure**: `terraform apply`

## 🐛 Troubleshooting

### Common Issues
- **Template Not Found**: Check `terraform-modules/templates/` directory
- **Invalid CIDR**: Ensure proper CIDR format (e.g., `10.0.0.0/16`)
- **Missing Environment Variables**: Copy and configure `.env` file

### Debug Mode
```python
# Enable debug logging in terraform_service.py
import logging
logging.basicConfig(level=logging.DEBUG)
```
