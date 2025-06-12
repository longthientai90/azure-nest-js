import {
  Controller,
  Get,
  Post,
  Body,
  Delete,
  Param,
  Put,
} from '@nestjs/common';
import { CosmosService } from './cosmos.service';

@Controller('items')
export class ItemsController {
  constructor(private readonly cosmosService: CosmosService) {}

  @Get()
  findAll() {
    return this.cosmosService.findAll();
  }

  @Post()
  create(@Body() item) {
    return this.cosmosService.create(item);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() item) {
    return this.cosmosService.update(id, item);
  }

  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.cosmosService.delete(id);
  }
}
