import { Inject, Injectable, Scope } from '@nestjs/common';
import { ConfigService } from "@nestjs/config";
import { REQUEST } from "@nestjs/core";
import { Company } from "./company.entity";
import { CosmosDbService } from "../../cosmos-db/cosmos-db.service";
import { ContainerName, DbName } from "../../cosmos-db/cosmos-db.const";
import { UpdateCompanyDto } from "./dto/update-company.dto";
import { CreateCompanyDto } from "./dto/create-company.dto";


@Injectable({ scope: Scope.REQUEST })
export class CompanyService {

  private container;

  constructor(
    @Inject(REQUEST)
    private readonly request: Request,
    private readonly cosmosDbService: CosmosDbService,
    private readonly configService: ConfigService,
  ) {
    this.container = this.cosmosDbService.getContainer(ContainerName.COMPANIES, DbName.ACCOUNT);
  }

  async findAll(): Promise<Company[]> {
    const { resources } = await this.container.items.query('SELECT * FROM c').fetchAll();
    return resources;
  }

  async findOne(id: string): Promise<Company> {
    const { resource } = await this.container.item(id, id).read();
    return resource as Company;
  }

  async create(data: CreateCompanyDto): Promise<Company> {
    const item = { id: Date.now().toString(), ...data };
    const { resource } = await this.container.items.create(item);
    return resource;
  }

  async update(id: string, data: UpdateCompanyDto): Promise<Company> {
    const { resource: existing } = await this.container.item(id, id).read();
    const updated = { ...existing, ...data };
    const { resource } = await this.container.items.upsert(updated);
    return resource as Company;
  }

  async remove(id: string): Promise<void> {
    await this.container.item(id, id).delete();
  }
}