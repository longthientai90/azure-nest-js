import { Injectable } from '@nestjs/common';
import { CosmosClient } from '@azure/cosmos';
import * as dotenv from 'dotenv';
dotenv.config();

@Injectable()
export class CosmosService {
  private container;

  constructor() {
    const client = new CosmosClient({
      endpoint: process.env.AZURE_COSMOS_ENDPOINT,
      key: process.env.AZURE_COSMOS_KEY,
    });
    const db = client.database(process.env.AZURE_COSMOS_DATABASE);
    this.container = db.container(process.env.AZURE_COSMOS_CONTAINER);
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
