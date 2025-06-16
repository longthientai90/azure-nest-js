import {
  Controller,
  Get,
  Post,
  Body,
  Delete,
  Param,
  Put,
} from '@nestjs/common';
import { ItemService } from './item.service';

@Controller('items')
export class ItemsController {
  constructor(private readonly cosmosService: ItemService) {}

  @Get()
  findAll() {
    console.log('Fetching all items from Cosmos DB');
    // This log is for debugging purposes to ensure the method is called
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
