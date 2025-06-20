import { CosmosClient } from '@azure/cosmos';
import { Inject, Injectable, Scope } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { REQUEST } from '@nestjs/core';
import { TenantPrefix } from "./cosmos-db.const";

@Injectable({ scope: Scope.REQUEST })
export class CosmosDbService {
  private client: CosmosClient;
  constructor(
    @Inject(REQUEST) private readonly request: Request,
    private readonly configService: ConfigService,
  ) {
    this.client = new CosmosClient({
      endpoint: this.configService.get<string>('AZURE_COSMOS_ENDPOINT'),
      key: this.configService.get<string>('AZURE_COSMOS_KEY'),
    });
  }

  getContainer(containerName: string, dbName?: string, tenantPrefix?: string, companyKey?: string) {
    let _dbName = dbName;
    // If dbName is not provided, use tenantPrefix and companyKey from request or user
    if(!_dbName) {
      const { user } = this.request as any;
      let _tenantPrefix = tenantPrefix || user.tenantPrefix;

      // If tenantPrefix is not provided, default to CREATIVE
      if(!_tenantPrefix) {
        _tenantPrefix = TenantPrefix.CREATIVE;
      }
      _dbName = `${_tenantPrefix}_${companyKey || user.companyKey}`;
    }

    console.log('=========== cosmos db ============', _dbName, containerName);
    return this.client.database(_dbName).container(containerName);
  }
}
