import { Module } from '@nestjs/common';
import { ItemService } from './item.service';
import { ItemsController } from './item.controller';
import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { CosmosDbModule } from '../cosmos-db/cosmos-db.module';

@Module({
  imports: [CosmosDbModule, HttpModule, ConfigModule],
  controllers: [ItemsController],
  providers: [ItemService],
  exports: [ItemService],
})
export class ItemModule {}
