import os
import json
import jinja2
import uuid
from datetime import datetime
from pathlib import Path


class TerraformService:
    def __init__(self, template_dir="../terraform-modules/templates", workspace_dir="terraform-workspaces"):
        self.template_dir = template_dir
        self.workspace_dir = workspace_dir
        
        # Resolve absolute paths
        current_dir = os.path.dirname(os.path.abspath(__file__))
        self.template_dir = os.path.join(current_dir, template_dir)
        self.workspace_dir = os.path.join(current_dir, workspace_dir)
        
        print(f"🔍 Template directory: {self.template_dir}")
        print(f"🔍 Workspace directory: {self.workspace_dir}")
        
        # Check if template directory exists
        if not os.path.exists(self.template_dir):
            print(f"⚠️  Template directory not found: {self.template_dir}")
            print("Creating template directory...")
            os.makedirs(self.template_dir, exist_ok=True)
        
        self.jinja_env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(self.template_dir),
            trim_blocks=True,
            lstrip_blocks=True
        )
        
        # Ensure workspace directory exists
        Path(self.workspace_dir).mkdir(parents=True, exist_ok=True)
    
    def validate_company_data(self, company_data):
        """Validate required fields in company data"""
        required_fields = [
            'company_name', 'company_slug', 'environment',
            'azure_region', 'vnet_cidr', 'public_subnet_cidr', 'private_subnet_cidr',
            'db_admin_username', 'api_container_image', 'web_container_image'
        ]
        
        missing_fields = [field for field in required_fields if field not in company_data]
        if missing_fields:
            raise ValueError(f"Missing required fields: {', '.join(missing_fields)}")
        
        # Validate CIDR format (basic validation)
        cidr_fields = ['vnet_cidr', 'public_subnet_cidr', 'private_subnet_cidr']
        for field in cidr_fields:
            if not self._is_valid_cidr(company_data[field]):
                raise ValueError(f"Invalid CIDR format for {field}: {company_data[field]}")
    
    def _is_valid_cidr(self, cidr):
        """Basic CIDR validation"""
        try:
            parts = cidr.split('/')
            if len(parts) != 2:
                return False
            
            ip_parts = parts[0].split('.')
            if len(ip_parts) != 4:
                return False
            
            for part in ip_parts:
                if not (0 <= int(part) <= 255):
                    return False
            
            prefix = int(parts[1])
            if not (0 <= prefix <= 32):
                return False
            
            return True
        except (ValueError, IndexError):
            return False
    
    def prepare_template_data(self, company_data):
        """Prepare and enhance company data for template rendering"""
        # Generate additional data
        enhanced_data = {
            **company_data,
            'timestamp': datetime.now().isoformat(),
            'resource_prefix': f"{company_data['company_slug']}-{company_data['environment']}",
            'company_id': str(uuid.uuid4()),
            
            # Default values for optional fields
            'terraform_state_rg': os.getenv('TERRAFORM_STATE_RG', 'terraform-state-rg'),
            'terraform_state_storage': os.getenv('TERRAFORM_STATE_STORAGE', 'terraformstatestorage'),
            'azure_subscription_id': os.getenv('AZURE_SUBSCRIPTION_ID'),
            'azure_tenant_id': os.getenv('AZURE_TENANT_ID'),
            'azure_client_id': os.getenv('AZURE_CLIENT_ID'),
            'azure_client_secret': os.getenv('AZURE_CLIENT_SECRET'),
        }
        
        return enhanced_data
    
    def render_template(self, template_name, data):
        """Render Jinja2 template with provided data"""
        try:
            template = self.jinja_env.get_template(template_name)
            rendered_content = template.render(**data)
            return rendered_content
        except jinja2.TemplateNotFound:
            raise FileNotFoundError(f"Template not found: {template_name}")
        except jinja2.TemplateError as e:
            raise ValueError(f"Template rendering error: {str(e)}")
    
    def create_workspace(self, company_slug):
        """Create workspace directory for company"""
        workspace_path = Path(self.workspace_dir) / company_slug
        workspace_path.mkdir(parents=True, exist_ok=True)
        return str(workspace_path)
    
    def write_terraform_files(self, workspace_path, files_content):
        """Write generated content to terraform files"""
        written_files = []
        
        for filename, content in files_content.items():
            file_path = Path(workspace_path) / filename
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            written_files.append(str(file_path))
        
        return written_files
    
    def generate_company_infrastructure(self, company_data):
        """Main method to generate complete terraform infrastructure for a company"""
        try:
            print(f"🚀 Starting infrastructure generation for: {company_data['company_name']}")
            
            # 1. Validate input data
            print("📝 Validating company data...")
            self.validate_company_data(company_data)
            
            # 2. Prepare template data
            print("🔧 Preparing template data...")
            template_data = self.prepare_template_data(company_data)
            
            # 3. Create workspace
            print(f"📁 Creating workspace for: {company_data['company_slug']}")
            workspace_path = self.create_workspace(company_data['company_slug'])
            
            # 4. Render templates
            print("🎨 Rendering Terraform templates...")
            files_content = {}
            
            # Main terraform file
            files_content['main.tf'] = self.render_template('company.tf.j2', template_data)
            
            # Variables file (if exists)
            try:
                files_content['terraform.tfvars'] = self.render_template('terraform.tfvars.j2', template_data)
            except FileNotFoundError:
                print("ℹ️  terraform.tfvars.j2 template not found, skipping...")
            
            # 5. Write files to workspace
            print("💾 Writing Terraform files...")
            written_files = self.write_terraform_files(workspace_path, files_content)
            
            # 6. Generate summary
            result = {
                'status': 'success',
                'company_id': template_data['company_id'],
                'company_name': company_data['company_name'],
                'company_slug': company_data['company_slug'],
                'workspace_path': workspace_path,
                'generated_files': written_files,
                'terraform_state_key': f"companies/{company_data['company_slug']}/terraform.tfstate",
                'generated_at': template_data['timestamp']
            }
            
            print("✅ Infrastructure generation completed successfully!")
            print(f"📂 Workspace: {workspace_path}")
            print(f"📄 Generated files: {len(written_files)}")
            
            return result
            
        except Exception as e:
            error_result = {
                'status': 'error',
                'error_message': str(e),
                'company_name': company_data.get('company_name', 'Unknown'),
                'generated_at': datetime.now().isoformat()
            }
            
            print(f"❌ Infrastructure generation failed: {str(e)}")
            return error_result
    
    def list_companies(self):
        """List all generated companies"""
        companies = []
        workspace_path = Path(self.workspace_dir)
        
        if workspace_path.exists():
            for company_dir in workspace_path.iterdir():
                if company_dir.is_dir():
                    main_tf_path = company_dir / 'main.tf'
                    if main_tf_path.exists():
                        companies.append({
                            'company_slug': company_dir.name,
                            'workspace_path': str(company_dir),
                            'has_main_tf': True,
                            'last_modified': datetime.fromtimestamp(main_tf_path.stat().st_mtime).isoformat()
                        })
        
        return companies
    
    def cleanup_company(self, company_slug):
        """Remove company workspace and files"""
        import shutil
        
        workspace_path = Path(self.workspace_dir) / company_slug
        if workspace_path.exists():
            shutil.rmtree(workspace_path)
            return True
        return False