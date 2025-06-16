import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import * as dotenv from 'dotenv';
import { ConfigService } from "@nestjs/config";
dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.setGlobalPrefix('api', {
    exclude: ['/'],
  });
  
  const appPort = configService.get<number>('app.port') || 4100;
  console.log('Starting NestJS application...', appPort);
  await app.listen(appPort);
}
bootstrap();
