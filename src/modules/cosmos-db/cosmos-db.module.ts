import { Module } from '@nestjs/common';
import { CosmosDbService } from './cosmos-db.service';

@Module({
  providers: [CosmosDbService],
  exports: [CosmosDbService],
})
export class CosmosDbModule {}
