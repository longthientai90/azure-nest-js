import { registerAs } from '@nestjs/config';

export default registerAs('azure', () => ({
  accessKeyId: process.env.ACCESS_KEY_ID,
  secretAccessKey: process.env.SECRET_ACCESS_KEY,
  azureCosmosdbUri: process.env.AZURE_COSMOS_ENDPOINT,
  azureCosmosdbKey: process.env.AZURE_COSMOS_KEY,
}));
