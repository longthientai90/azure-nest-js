import { Inject, Injectable, Scope } from '@nestjs/common';
import { ContainerName, CosmosDbService } from '../cosmos-db/cosmos-db.service';
import { ConfigService } from "@nestjs/config";
import { REQUEST } from "@nestjs/core";

@Injectable({ scope: Scope.REQUEST })
export class ItemService {
  private container;

  constructor(
    @Inject(REQUEST)
    private readonly request: Request,
    private readonly cosmosDbService: CosmosDbService,
    private readonly configService: ConfigService,
  ) {
    this.container = this.cosmosDbService.getContainer(ContainerName.ITEM);
  }

  async findAll() {
    const { resources } = await this.container.items
      .query('SELECT * FROM c')
      .fetchAll();
    return resources;
  }

  async create(item) {
    const { resource } = await this.container.items.create(item);
    return resource;
  }

  async update(id, item) {
    return await this.container.item(id, undefined).replace(item);
  }

  async delete(id) {
    return await this.container.item(id, undefined).delete();
  }
}
