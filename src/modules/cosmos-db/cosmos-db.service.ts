import { CosmosClient } from '@azure/cosmos';
import { Inject, Injectable, Scope } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { REQUEST } from '@nestjs/core';

export enum ContainerName {
  AGENTS = 'agents',
  GROUPS = 'groups',
  ITEM = 'items',
}

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

  getContainer(containerName: string) {
    const dbName = this.configService.get<string>('AZURE_COSMOS_DATABASE') || '';
    if (dbName === '') {
      throw new Error('AZURE_COSMOS_DATABASE is not defined in configuration');
    }

    console.log('=========== cosmos db ============', dbName, containerName);
    return this.client.database(dbName).container(containerName);
  }
}
